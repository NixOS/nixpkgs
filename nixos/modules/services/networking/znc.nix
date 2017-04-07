{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.znc;

  defaultUser = "znc"; # Default user to own process.

  # Default user and pass:
  # un=znc
  # pw=nixospass

  defaultUserName = "znc";
  defaultPassBlock = "
        <Pass password>
                Method = sha256
                Hash = e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93
                Salt = l5Xryew4g*!oa(ECfX2o
        </Pass>
  ";

  modules = pkgs.buildEnv {
    name = "znc-modules";
    paths = cfg.modulePackages;
  };

  # Keep znc.conf in nix store, then symlink or copy into `dataDir`, depending on `mutable`.
  notNull = a: ! isNull a;
  mkZncConf = confOpts: ''
    Version = 1.6.3
    ${concatMapStrings (n: "LoadModule = ${n}\n") confOpts.modules}

    <Listener l>
            Port = ${toString confOpts.port}
            IPv4 = true
            IPv6 = true
            SSL = ${if confOpts.useSSL then "true" else "false"}
    </Listener>
    
    <User ${confOpts.userName}>
            ${confOpts.passBlock}
            Admin = true
            Nick = ${confOpts.nick}
            AltNick = ${confOpts.nick}_
            Ident = ${confOpts.nick}
            RealName = ${confOpts.nick}
            ${concatMapStrings (n: "LoadModule = ${n}\n") confOpts.userModules}

            ${ lib.concatStringsSep "\n" (lib.mapAttrsToList (name: net: ''
              <Network ${name}>
                  ${concatMapStrings (m: "LoadModule = ${m}\n") net.modules}
                  Server = ${net.server} ${if net.useSSL then "+" else ""}${toString net.port}

                  ${concatMapStrings (c: "<Chan #${c}>\n</Chan>\n") net.channels}
              </Network>
              '') confOpts.networks) }
    </User>
    ${confOpts.extraZncConf}
  '';

  zncConfFile = pkgs.writeTextFile {
    name = "znc.conf";
    text = if cfg.zncConf != ""
      then cfg.zncConf
      else mkZncConf cfg.confOptions;
  };

  networkOpts = { ... }: {
    options = {
      server = mkOption {
        type = types.str;
        example = "chat.freenode.net";
        description = ''
          IRC server address.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 6697;
        example = 6697;
        description = ''
          IRC server port.
        '';
      };

      useSSL = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use SSL to connect to the IRC server.
        '';
      };

      modulePackages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = [ "pkgs.zncModules.push" "pkgs.zncModules.fish" ];
        description = ''
          External ZNC modules to build.
        '';
      };

      modules = mkOption {
        type = types.listOf types.str;
        default = [ "simple_away" ];
        example = literalExample "[ simple_away sasl ]";
        description = ''
          ZNC modules to load.
        '';
      };

      channels = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "nixos" ];
        description = ''
          IRC channels to join.
        '';
      };
    };
  };

in

{

  ###### Interface

  options = {
    services.znc = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable a ZNC service for a user.
        '';
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

      confOptions = {
        modules = mkOption {
          type = types.listOf types.str;
          default = [ "webadmin" "adminlog" ];
          example = [ "partyline" "webadmin" "adminlog" "log" ];
          description = ''
            A list of modules to include in the `znc.conf` file.
          '';
        };

        userModules = mkOption {
          type = types.listOf types.str;
          default = [ "chansaver" "controlpanel" ];
          example = [ "chansaver" "controlpanel" "fish" "push" ];
          description = ''
            A list of user modules to include in the `znc.conf` file.
          '';
        };

        userName = mkOption {
          default = defaultUserName;
          example = "johntron";
          type = types.string;
          description = ''
            The user name used to log in to the ZNC web admin interface.
          '';
        };

        networks = mkOption {
          default = { };
          type = with types; attrsOf (submodule networkOpts);
          description = ''
            IRC networks to connect the user to.
          '';
          example = {
            "freenode" = {
              server = "chat.freenode.net";
              port = 6697;
              ssl = true;
              modules = [ "simple_away" ];
            };
          };
        };

        nick = mkOption {
          default = "znc-user";
          example = "john";
          type = types.string;
          description = ''
            The IRC nick.
          '';
        };

        passBlock = mkOption {
          example = defaultPassBlock;
          type = types.string;
          description = ''
            Generate with znc --makepass.
            This is the password used to log in to the ZNC web admin interface.
          '';
        };

        port = mkOption {
          default = 5000;
          example = 5000;
          type = types.int;
          description = ''
            Specifies the port on which to listen.
          '';
        };

        useSSL = mkOption {
          default = true;
          type = types.bool;
          description = ''
            Indicates whether the ZNC server should use SSL when listening on the specified port. A self-signed certificate will be generated.
          '';
        };

        extraZncConf = mkOption {
          default = "";
          type = types.lines;
          description = ''
            Extra config to `znc.conf` file.
          '';
        };
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
        default = false;
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

    systemd.services.znc = {
      description = "ZNC Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.service" ];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop   = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
      };
      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -p ${cfg.dataDir}/configs

        # If mutable, regenerate conf file every time.
        ${optionalString (!cfg.mutable) ''
          ${pkgs.coreutils}/bin/echo "znc is set to be system-managed. Now deleting old znc.conf file to be regenerated."
          ${pkgs.coreutils}/bin/rm -f ${cfg.dataDir}/configs/znc.conf
        ''}

        # Ensure essential files exist.
        if [[ ! -f ${cfg.dataDir}/configs/znc.conf ]]; then
            ${pkgs.coreutils}/bin/echo "No znc.conf file found in ${cfg.dataDir}. Creating one now."
            ${pkgs.coreutils}/bin/cp --no-clobber ${zncConfFile} ${cfg.dataDir}/configs/znc.conf
            ${pkgs.coreutils}/bin/chmod u+rw ${cfg.dataDir}/configs/znc.conf
            ${pkgs.coreutils}/bin/chown ${cfg.user} ${cfg.dataDir}/configs/znc.conf
        fi

        if [[ ! -f ${cfg.dataDir}/znc.pem ]]; then
          ${pkgs.coreutils}/bin/echo "No znc.pem file found in ${cfg.dataDir}. Creating one now."
          ${pkgs.znc}/bin/znc --makepem --datadir ${cfg.dataDir} 
        fi

        # Symlink modules
        rm ${cfg.dataDir}/modules || true
        ln -fs ${modules}/lib/znc ${cfg.dataDir}/modules
      '';
      script = "${pkgs.znc}/bin/znc --foreground --datadir ${cfg.dataDir} ${toString cfg.extraFlags}";
    };

    users.extraUsers = optional (cfg.user == defaultUser)
      { name = defaultUser;
        description = "ZNC server daemon owner";
        group = defaultUser;
        uid = config.ids.uids.znc;
        home = cfg.dataDir;
        createHome = true;
      };
 
    users.extraGroups = optional (cfg.user == defaultUser)
      { name = defaultUser;
        gid = config.ids.gids.znc;
        members = [ defaultUser ];
      };

  };
}
