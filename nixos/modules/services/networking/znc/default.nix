{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.znc;


  # Converts a semantic config to a string
  semanticToString = cfg: let

    getAttrs = set: sort (a: b:
      # Attributes should be last
      if a == "extraConfig"
        then false # Always put extraConfig last
        else if builtins.isAttrs set.${a}
          # Attributes should be last
          then if builtins.isAttrs set.${b} then a < b else false
          else if builtins.isAttrs set.${b} then true else a < b
    ) (builtins.attrNames set);

    toLines = set: flatten (map (name: let
      value = set.${name};
      atom = val: {
        bool = "${name} = ${if val then "true" else "false"}";
        string = if name == "extraConfig" then val else "${name} = ${val}";
        int = "${name} = ${toString val}";
        null = [];
      };
      forType = atom value // {

        set = map (subname: let
          subvalue = value.${subname};
        in if subvalue == null then [] else [
          "<${name} ${subname}>"
          (map (line: "\t${line}") (toLines subvalue))
          "</${name}>"
        ]) (builtins.attrNames value);

        list = map (elem: (atom elem).${builtins.typeOf elem}) value;

      }; in
        forType.${builtins.typeOf value}
    ) (getAttrs set));

  in concatStringsSep "\n" (toLines cfg);

  semanticTypes = with types; rec {
    zncAtom = either (either int bool) str;
    zncList = listOf zncAtom;
    zncAttr = attrsOf (nullOr zncConf);
    zncAll = nullOr (either (either zncAtom zncList) zncAttr);
    zncConf = attrsOf (zncAll // {
      description = "znc values (null, atoms (str, int, bool), list of atoms, or attrsets of znc values)";
    });
  };

  defaultUser = "znc"; # Default user to own process.

  modules = pkgs.buildEnv {
    name = "znc-modules";
    paths = cfg.modulePackages;
  };

in

{

  options = {
    services.znc = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable a ZNC service for a user.
        '';
      };

      config = mkOption {
        default = {};
        type = semanticTypes.zncConf;
        description = ''
          semantic ZNC config, represented as
        '';
      };

      configFile = mkOption {
        type = types.path;
        description = "config file";
      };

      user = mkOption {
        default = "znc";
        example = "john";
        type = types.string;
        description = ''
          The name of an existing user account to use to own the ZNC server process.
          If not specified, a default user will be created to own the process.
        '';
      };

      group = mkOption {
        default = "";
        example = "users";
        type = types.string;
        description = ''
          Group to own the ZNCserver process.
        '';
      };

      dataDir = mkOption {
        default = "/var/lib/znc/";
        example = "/home/john/.znc/";
        type = types.path;
        description = ''
          The data directory. Used for configuration files and modules.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for ZNC.
        '';
      };

      zncConf = mkOption {
        default = "";
        example = "See: http://wiki.znc.in/Configuration";
        type = types.lines;
        description = ''
          Config file as generated with `znc --makeconf` to use for the whole ZNC configuration.
          If specified, `confOptions` will be ignored, and this value, as-is, will be used.
          If left empty, a conf file with default values will be used.
        '';
      };

      confOptions = mkOption {
        type = types.submodule (import ./opts.nix);
        example = literalExample ''

        '';
        description = ''
          The full legacy config style which isn't as flexible as the new one
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
        default = true;
        type = types.bool;
        description = ''
          Indicates whether to allow the contents of the `dataDir` directory to be changed
          by the user at run-time.
          If true, modifications to the ZNC configuration after its initial creation are not
            overwritten by a NixOS system rebuild.
          If false, the ZNC configuration is rebuilt by every system rebuild.
          If the user wants to manage the ZNC service using the web admin interface, this value
            should be set to true.
        '';
      };

      extraFlags = mkOption {
        default = [ ];
        example = [ "--debug" ];
        type = types.listOf types.str;
        description = ''
          Extra flags to use when executing znc command.
        '';
      };
    };
  };


  ###### Implementation

  config = mkIf cfg.enable {

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = flatten (map (l: l.Port or []) (builtins.attrValues (cfg.config.Listener or {})));
    };

    services.znc = {
      config = let c = cfg.confOptions; in {
        Version = (builtins.parseDrvName pkgs.znc.name).version;
        LoadModule = c.modules;
        Listener.l = {
          Port = c.port;
          IPv4 = true;
          IPv6 = true;
          SSL = c.useSSL;
        };
        User.${c.userName} = {
          Admin = mkDefault true;
          Nick = mkDefault c.nick;
          AltNick = mkDefault "${c.nick}_";
          Ident = mkDefault c.nick;
          RealName = mkDefault c.nick;
          LoadModule = mkDefault c.userModules;
          Network = mapAttrs (name: net: {
            LoadModule = mkDefault net.modules;
            Server = mkDefault "${net.server} ${optionalString net.useSSL "+"}${toString net.port} ${net.password}";
            Chan = mkDefault (optionalAttrs net.hasBitlbeeControlChannel { "&bitlbee" = {}; } //
              listToAttrs (map (n: nameValuePair n {}) net.channels));
            extraConfig = (if net.extraConf == "" then null else net.extraConf);
          }) c.networks;
          extraConfig = mkDefault ([
            c.passBlock
          ] ++ optional (c.extraZncConf != "") c.extraZncConf);
        };
      };
      configFile = pkgs.writeText "znc.conf" (semanticToString cfg.config);
    };

    systemd.services.znc = {
      description = "ZNC Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        ExecStart = "${pkgs.znc}/bin/znc --foreground --datadir ${cfg.dataDir} ${toString cfg.extraFlags}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop   = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
      };
      preStart = ''
        filepath="${cfg.dataDir}/configs/znc.conf"
        mkdir -p "$(dirname "$filepath")"

        # If mutable, regenerate conf file every time.
        ${optionalString (!cfg.mutable) ''
          echo "znc is set to be system-managed. Now deleting old znc.conf file to be regenerated."
          rm -f "$filepath"
        ''}

        # Ensure essential files exist.
        if [[ ! -f "$filepath" ]]; then
            echo "No znc.conf file found in ${cfg.dataDir}. Creating one now."
            cp --no-clobber ${cfg.configFile} "$filepath"
            chmod u+rw "$filepath"
            chown ${cfg.user} "$filepath"
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
