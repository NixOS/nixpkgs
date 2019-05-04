{ config, lib, pkgs, ...}:

with lib;

let

  cfg = config.services.znc;

  defaultUser = "znc";

  modules = pkgs.buildEnv {
    name = "znc-modules";
    paths = cfg.modulePackages;
  };

  listenerPorts = concatMap (l: optional (l ? Port) l.Port)
    (attrValues (cfg.config.Listener or {}));

  # Converts the config option to a string
  semanticString = let

      sortedAttrs = set: sort (l: r:
        if l == "extraConfig" then false # Always put extraConfig last
        else if isAttrs set.${l} == isAttrs set.${r} then l < r
        else isAttrs set.${r} # Attrsets should be last, makes for a nice config
        # This last case occurs when any side (but not both) is an attrset
        # The order of these is correct when the attrset is on the right
        # which we're just returning
      ) (attrNames set);

      # Specifies an attrset that encodes the value according to its type
      encode = name: value: {
          null = [];
          bool = [ "${name} = ${boolToString value}" ];
          int = [ "${name} = ${toString value}" ];

          # extraConfig should be inserted verbatim
          string = [ (if name == "extraConfig" then value else "${name} = ${value}") ];

          # Values like `Foo = [ "bar" "baz" ];` should be transformed into
          #   Foo=bar
          #   Foo=baz
          list = concatMap (encode name) value;

          # Values like `Foo = { bar = { Baz = "baz"; Qux = "qux"; Florps = null; }; };` should be transmed into
          #   <Foo bar>
          #     Baz=baz
          #     Qux=qux
          #   </Foo>
          set = concatMap (subname: [
              "<${name} ${subname}>"
            ] ++ map (line: "\t${line}") (toLines value.${subname}) ++ [
              "</${name}>"
            ]) (filter (v: v != null) (attrNames value));

        }.${builtins.typeOf value};

      # One level "above" encode, acts upon a set and uses encode on each name,value pair
      toLines = set: concatMap (name: encode name set.${name}) (sortedAttrs set);

    in
      concatStringsSep "\n" (toLines cfg.config);

  semanticTypes = with types; rec {
    zncAtom = nullOr (either (either int bool) str);
    zncAttr = attrsOf (nullOr zncConf);
    zncAll = either (either zncAtom (listOf zncAtom)) zncAttr;
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
      enable = mkEnableOption "ZNC";

      user = mkOption {
        default = "znc";
        example = "john";
        type = types.str;
        description = ''
          The name of an existing user account to use to own the ZNC server
          process. If not specified, a default user will be created.
        '';
      };

      group = mkOption {
        default = defaultUser;
        example = "users";
        type = types.str;
        description = ''
          Group to own the ZNC process.
        '';
      };

      dataDir = mkOption {
        default = "/var/lib/znc/";
        example = "/home/john/.znc/";
        type = types.path;
        description = ''
          The state directory for ZNC. The config and the modules will be linked
          to from this directory as well.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for ZNC. Does work with
          ports for listeners specified in
          <option>services.znc.config.Listener</option>.
        '';
      };

      config = mkOption {
        type = semanticTypes.zncConf;
        default = {};
        example = literalExample ''
          {
            LoadModule = [ "webadmin" "adminlog" ];
            User.paul = {
              Admin = true;
              Nick = "paul";
              AltNick = "paul1";
              LoadModule = [ "chansaver" "controlpanel" ];
              Network.freenode = {
                Server = "chat.freenode.net +6697";
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
          <link xlink:href="https://wiki.znc.in/Configuration"/> for details. The
          Nix value declared here will be translated directly to the xml-like
          format ZNC expects. This is much more flexible than the legacy options
          under <option>services.znc.confOptions.*</option>, but also can't do
          any type checking.
          </para>
          <para>
          You can use <command>nix-instantiate --eval --strict '&lt;nixpkgs/nixos&gt;' -A config.services.znc.config</command>
          to view the current value. By default it contains a listener for port
          5000 with SSL enabled.
          </para>
          <para>
          Nix attributes called <literal>extraConfig</literal> will be inserted
          verbatim into the resulting config file.
          </para>
          <para>
          If <option>services.znc.useLegacyConfig</option> is turned on, the
          option values in <option>services.znc.confOptions.*</option> will be
          gracefully be applied to this option.
          </para>
          <para>
          If you intend to update the configuration through this option, be sure
          to enable <option>services.znc.mutable</option>, otherwise none of the
          changes here will be applied after the initial deploy.
        '';
      };

      configFile = mkOption {
        type = types.path;
        example = "~/.znc/configs/znc.conf";
        description = ''
          Configuration file for ZNC. It is recommended to use the
          <option>config</option> option instead.
          </para>
          <para>
          Setting this option will override any auto-generated config file
          through the <option>confOptions</option> or <option>config</option>
          options.
        '';
      };

      modulePackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExample "[ pkgs.zncModules.fish pkgs.zncModules.push ]";
        description = ''
          A list of global znc module packages to add to znc.
        '';
      };

      mutable = mkOption {
        default = true; # TODO: Default to true when config is set, make sure to not delete the old config if present
        type = types.bool;
        description = ''
          Indicates whether to allow the contents of the
          <literal>dataDir</literal> directory to be changed by the user at
          run-time.
          </para>
          <para>
          If enabled, modifications to the ZNC configuration after its initial
          creation are not overwritten by a NixOS rebuild. If disabled, the
          ZNC configuration is rebuilt on every NixOS rebuild.
          </para>
          <para>
          If the user wants to manage the ZNC service using the web admin
          interface, this option should be enabled.
        '';
      };

      extraFlags = mkOption {
        default = [ ];
        example = [ "--debug" ];
        type = types.listOf types.str;
        description = ''
          Extra arguments to use for executing znc.
        '';
      };
    };
  };


  ###### Implementation

  config = mkIf cfg.enable {

    services.znc = {
      configFile = mkDefault (pkgs.writeText "znc-generated.conf" semanticString);
      config = {
        Version = (builtins.parseDrvName pkgs.znc.name).version;
        Listener.l.Port = mkDefault 5000;
        Listener.l.SSL = mkDefault true;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall listenerPorts;

    systemd.services.znc = {
      description = "ZNC Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        ExecStart = "${pkgs.znc}/bin/znc --foreground --datadir ${cfg.dataDir} ${escapeShellArgs cfg.extraFlags}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
      };
      preStart = ''
        mkdir -p ${cfg.dataDir}/configs

        # If mutable, regenerate conf file every time.
        ${optionalString (!cfg.mutable) ''
          echo "znc is set to be system-managed. Now deleting old znc.conf file to be regenerated."
          rm -f ${cfg.dataDir}/configs/znc.conf
        ''}

        # Ensure essential files exist.
        if [[ ! -f ${cfg.dataDir}/configs/znc.conf ]]; then
            echo "No znc.conf file found in ${cfg.dataDir}. Creating one now."
            cp --no-clobber ${cfg.configFile} ${cfg.dataDir}/configs/znc.conf
            chmod u+rw ${cfg.dataDir}/configs/znc.conf
            chown ${cfg.user} ${cfg.dataDir}/configs/znc.conf
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

    users.users = optional (cfg.user == defaultUser)
      { name = defaultUser;
        description = "ZNC server daemon owner";
        group = defaultUser;
        uid = config.ids.uids.znc;
        home = cfg.dataDir;
        createHome = true;
      };

    users.groups = optional (cfg.user == defaultUser)
      { name = defaultUser;
        gid = config.ids.gids.znc;
        members = [ defaultUser ];
      };

  };
}
