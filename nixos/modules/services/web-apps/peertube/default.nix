{ lib, pkgs, config, ... }:

let
  name = "peertube";
  cfg = config.services.peertube;

  uid = config.ids.uids.peertube;
  gid = config.ids.gids.peertube;
in
{
  options.services.peertube = {
    enable = lib.mkEnableOption "Enable Peertube’s service";

    user = lib.mkOption {
      type = lib.types.str;
      default = name;
      description = "User account under which Peertube runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = name;
      description = "Group under which Peertube runs";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/${name}";
      description = ''
        The directory where Peertube stores its data.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        The configuration file path for Peertube.
        '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.webapps.peertube;
      description = ''
        Peertube package to use.
        '';
    };

    # Output variables
    systemdStateDirectory = lib.mkOption {
      type = lib.types.str;

      # Use ReadWritePaths= instead if varDir is outside of /var/lib
      default = assert lib.strings.hasPrefix "/var/lib/" cfg.dataDir;
        lib.strings.removePrefix "/var/lib/" cfg.dataDir;

      description = ''
      Adjusted Peertube data directory for systemd
      '';

      readOnly = true;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.optionalAttrs (cfg.user == name) (lib.singleton {
      inherit name;
      inherit uid;
      group = cfg.group;
      description = "Peertube user";
      home = cfg.dataDir;
      useDefaultShell = true;
    });

    users.groups = lib.optionalAttrs (cfg.group == name) (lib.singleton {
      inherit name;
      inherit gid;
    });

    systemd.services.peertube = {
      description = "Peertube";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" ];
      wants = [ "postgresql.service" ];

      environment.NODE_CONFIG_DIR = "${cfg.dataDir}/config";
      environment.NODE_ENV = "production";
      environment.HOME = cfg.package;

      path = [ pkgs.nodejs pkgs.bashInteractive pkgs.ffmpeg pkgs.openssl ];

      script = ''
        install -m 0750 -d ${cfg.dataDir}/config
        ln -sf ${cfg.configFile} ${cfg.dataDir}/config/production.yaml
        exec npm run start
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.package;
        StateDirectory = cfg.systemdStateDirectory;
        StateDirectoryMode = 0750;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectControlGroups = true;
        Restart = "always";
        Type = "simple";
        TimeoutSec = 60;
      };

      unitConfig.RequiresMountsFor = cfg.dataDir;
    };
  };
}

