{ config, lib, pkgs, ...}:

let

  cfg = config.services.znc;

  defaultUser = "znc";

  modules = pkgs.buildEnv {
    name = "znc-modules";
    paths = cfg.modulePackages;
  };

  listenerPorts = lib.concatMap (l: lib.optional (l ? Port) l.Port)
    (lib.attrValues (cfg.config.Listener or {}));

  # Converts the config option to a string
  semanticString = let

      sortedAttrs = set: lib.sort (l: r:
        if l == "extraConfig" then false # Always put extraConfig last
        else if lib.isAttrs set.${l} == lib.isAttrs set.${r} then l < r
        else lib.isAttrs set.${r} # Attrsets should be last, makes for a nice config
        # This last case occurs when any side (but not both) is an attrset
        # The order of these is correct when the attrset is on the right
        # which we're just returning
      ) (lib.attrNames set);

      # Specifies an attrset that encodes the value according to its type
      encode = name: value: {
          null = [];
          bool = [ "${name} = ${lib.boolToString value}" ];
          int = [ "${name} = ${toString value}" ];

          # extraConfig should be inserted verbatim
          string = [ (if name == "extraConfig" then value else "${name} = ${value}") ];

          # Values like `Foo = [ "bar" "baz" ];` should be transformed into
          #   Foo=bar
          #   Foo=baz
          list = lib.concatMap (encode name) value;

          # Values like `Foo = { bar = { Baz = "baz"; Qux = "qux"; Florps = null; }; };` should be transmed into
          #   <Foo bar>
          #     Baz=baz
          #     Qux=qux
          #   </Foo>
          set = lib.concatMap (subname: lib.optionals (value.${subname} != null) ([
              "<${name} ${subname}>"
            ] ++ map (line: "\t${line}") (toLines value.${subname}) ++ [
              "</${name}>"
            ])) (lib.filter (v: v != null) (lib.attrNames value));

        }.${builtins.typeOf value};

      # One level "above" encode, acts upon a set and uses encode on each name,value pair
      toLines = set: lib.concatMap (name: encode name set.${name}) (sortedAttrs set);

    in
      lib.concatStringsSep "\n" (toLines cfg.config);

  semanticTypes = with lib.types; rec {
    zncAtom = nullOr (oneOf [ int bool str ]);
    zncAttr = attrsOf (nullOr zncConf);
    zncAll = oneOf [ zncAtom (listOf zncAtom) zncAttr ];
    zncConf = attrsOf (zncAll // {
      # Since this is a recursive type and the description by default contains
      # the description of its subtypes, infinite recursion would occur without
      # explicitly breaking this cycle
      description = "znc values (null, atoms (str, int, bool), list of atoms, or attrsets of znc values)";
    });
  };

in

{

  imports = [ ./options.nix ];

  options = {
    services.znc = {
      enable = lib.mkEnableOption "ZNC";

      user = lib.mkOption {
        default = "znc";
        example = "john";
        type = lib.types.str;
        description = ''
          The name of an existing user account to use to own the ZNC server
          process. If not specified, a default user will be created.
        '';
      };

      group = lib.mkOption {
        default = defaultUser;
        example = "users";
        type = lib.types.str;
        description = ''
          Group to own the ZNC process.
        '';
      };

      dataDir = lib.mkOption {
        default = "/var/lib/znc";
        example = "/home/john/.znc";
        type = lib.types.path;
        description = ''
          The state directory for ZNC. The config and the modules will be linked
          to from this directory as well.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for ZNC. Does work with
          ports for listeners specified in
          {option}`services.znc.config.Listener`.
        '';
      };

      config = lib.mkOption {
        type = semanticTypes.zncConf;
        default = {};
        example = lib.literalExpression ''
          {
            LoadModule = [ "webadmin" "adminlog" ];
            User.paul = {
              Admin = true;
              Nick = "paul";
              AltNick = "paul1";
              LoadModule = [ "chansaver" "controlpanel" ];
              Network.libera = {
                Server = "irc.libera.chat +6697";
                LoadModule = [ "simple_away" ];
                Chan = {
                  "#nixos" = { Detached = false; };
                  "##linux" = { Disabled = true; };
                };
              };
              Pass.password = {
                Method = "sha256";
                Hash = "e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93";
                Salt = "l5Xryew4g*!oa(ECfX2o";
              };
            };
          }
        '';
        description = ''
          Configuration for ZNC, see
          <https://wiki.znc.in/Configuration> for details. The
          Nix value declared here will be translated directly to the xml-like
          format ZNC expects. This is much more flexible than the legacy options
          under {option}`services.znc.confOptions.*`, but also can't do
          any type checking.

          You can use {command}`nix-instantiate --eval --strict '<nixpkgs/nixos>' -A config.services.znc.config`
          to view the current value. By default it contains a listener for port
          5000 with SSL enabled.

          Nix attributes called `extraConfig` will be inserted
          verbatim into the resulting config file.

          If {option}`services.znc.useLegacyConfig` is turned on, the
          option values in {option}`services.znc.confOptions.*` will be
          gracefully be applied to this option.

          If you intend to update the configuration through this option, be sure
          to disable {option}`services.znc.mutable`, otherwise none of the
          changes here will be applied after the initial deploy.
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        example = lib.literalExpression "~/.znc/configs/znc.conf";
        description = ''
          Configuration file for ZNC. It is recommended to use the
          {option}`config` option instead.

          Setting this option will override any auto-generated config file
          through the {option}`confOptions` or {option}`config`
          options.
        '';
      };

      modulePackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.zncModules.fish pkgs.zncModules.push ]";
        description = ''
          A list of global znc module packages to add to znc.
        '';
      };

      mutable = lib.mkOption {
        default = true; # TODO: Default to true when config is set, make sure to not delete the old config if present
        type = lib.types.bool;
        description = ''
          Indicates whether to allow the contents of the
          `dataDir` directory to be changed by the user at
          run-time.

          If enabled, modifications to the ZNC configuration after its initial
          creation are not overwritten by a NixOS rebuild. If disabled, the
          ZNC configuration is rebuilt on every NixOS rebuild.

          If the user wants to manage the ZNC service using the web admin
          interface, this option should be enabled.
        '';
      };

      extraFlags = lib.mkOption {
        default = [ ];
        example = [ "--debug" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Extra arguments to use for executing znc.
        '';
      };
    };
  };


  ###### Implementation

  config = lib.mkIf cfg.enable {

    services.znc = {
      configFile = lib.mkDefault (pkgs.writeText "znc-generated.conf" semanticString);
      config = {
        Version = lib.getVersion pkgs.znc;
        Listener.l.Port = lib.mkDefault 5000;
        Listener.l.SSL = lib.mkDefault true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall listenerPorts;

    systemd.services.znc = {
      description = "ZNC Server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        ExecStart = "${pkgs.znc}/bin/znc --foreground --datadir ${cfg.dataDir} ${lib.escapeShellArgs cfg.extraFlags}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
        # Hardening
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [ cfg.dataDir ];
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
        UMask = "0027";
      };
      preStart = ''
        mkdir -p ${cfg.dataDir}/configs

        # If mutable, regenerate conf file every time.
        ${lib.optionalString (!cfg.mutable) ''
          echo "znc is set to be system-managed. Now deleting old znc.conf file to be regenerated."
          rm -f ${cfg.dataDir}/configs/znc.conf
        ''}

        # Ensure essential files exist.
        if [[ ! -f ${cfg.dataDir}/configs/znc.conf ]]; then
            echo "No znc.conf file found in ${cfg.dataDir}. Creating one now."
            cp --no-preserve=ownership --no-clobber ${cfg.configFile} ${cfg.dataDir}/configs/znc.conf
            chmod u+rw ${cfg.dataDir}/configs/znc.conf
        fi

        if [[ ! -f ${cfg.dataDir}/znc.pem ]]; then
          echo "No znc.pem file found in ${cfg.dataDir}. Creating one now."
          ${pkgs.znc}/bin/znc --makepem --datadir ${cfg.dataDir}
        fi

        # Symlink modules
        rm ${cfg.dataDir}/modules || true
        ln -fs ${modules}/lib/znc ${cfg.dataDir}/modules
      '';
    };

    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} =
        { description = "ZNC server daemon owner";
          group = defaultUser;
          uid = config.ids.uids.znc;
          home = cfg.dataDir;
          createHome = true;
        };
      };

    users.groups = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} =
        { gid = config.ids.gids.znc;
          members = [ defaultUser ];
        };
    };

  };
}
