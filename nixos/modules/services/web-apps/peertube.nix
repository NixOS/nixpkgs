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

    configFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        The configuration file path for Peertube.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        description = "Configure local PostgreSQL database server for PeerTube.";
        type = lib.types.bool;
        default = true;
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "peertube_prod";
        description = "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "peertube";
        description = "Database user.";
      };
    };

    smtp = {
      createLocally = lib.mkOption {
        description = "Configure local Postfix SMTP server for PeerTube.";
        type = lib.types.bool;
        default = true;
      };
    };

    redis = {
      createLocally = lib.mkOption {
        description = "Configure local Redis server for PeerTube.";
        type = lib.types.bool;
        default = true;
      };
    };

    runtimeDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/${name}";
      description = "The directory where Peertube stores its runtime data.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.peertube;
      description = ''
        Peertube package to use.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.optionalAttrs (cfg.user == name) {
      "${name}" = {
        inherit uid;
        group = cfg.group;
        description = "Peertube user";
        home = cfg.runtimeDir;
        useDefaultShell = true;
        # todo: fix this. needed for postgres authentication
        password = "peertube";
      };
    };
    users.groups = lib.optionalAttrs (cfg.group == name) {
      "${name}" = {
        inherit gid;
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureUsers = [ { name = cfg.database.user; }];
      # The database is created as a startup script of the peertube service.
      authentication = ''
        host ${cfg.database.name} ${cfg.database.user} 127.0.0.1/32 trust
        host ${cfg.database.name} ${cfg.database.user} 127.0.0.1/32 md5
      '';
    };

    services.postfix = lib.mkIf cfg.smtp.createLocally {
      enable = true;
    };

    services.redis = lib.mkIf cfg.redis.createLocally {
      enable = true;
    };

    # Make sure the runtimeDir exists with the desired permissions.
    systemd.tmpfiles.rules = [
      "d \"${cfg.runtimeDir}\" - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.peertube = {
      description = "Peertube";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" "redis.service" ];
      wants = [ "postgresql.service" "redis.service" ];

      environment.NODE_CONFIG_DIR = "${cfg.runtimeDir}/config";
      environment.NODE_ENV = "production";
      environment.HOME = cfg.package;

      path = [ pkgs.nodejs pkgs.bashInteractive pkgs.ffmpeg pkgs.openssl pkgs.sudo pkgs.youtube-dl ];

      script = ''
        install -m 0750 -d ${cfg.runtimeDir}/config
        ln -sf ${cfg.configFile} ${cfg.runtimeDir}/config/production.yaml
        exec npm start
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.package;
        StateDirectory = "peertube";
        StateDirectoryMode = "0750";
        PrivateTmp = true;
        ProtectHome = true;
        ProtectControlGroups = true;
        ProtectSystem = "full";
        Restart = "always";
        Type = "simple";
        TimeoutSec = 60;
        CapabilityBoundingSet = "~CAP_SYS_ADMIN";
        ExecStartPre = let script = pkgs.writeScript "peertube-pre-start.sh" ''
          #!/bin/sh
          set -e

          if ! [ -e "${cfg.runtimeDir}/.first_run" ]; then
            set -v
            if [ -e "${cfg.runtimeDir}/.first_run_partial" ]; then
              echo "Warn: first run was interrupted"
            fi
            touch "${cfg.runtimeDir}/.first_run_partial"

            echo "Running PeerTube's PostgreSQL initialization..."
            echo "PeerTube is known to work with PostgreSQL v12, if any error occurs, please check your version."

            sudo -u postgres "${config.services.postgresql.package}/bin/createdb" -O ${cfg.database.user} -E UTF8 -T template0 ${cfg.database.name}
            sudo -u postgres "${config.services.postgresql.package}/bin/psql" -c "CREATE EXTENSION pg_trgm;" ${cfg.database.name}
            sudo -u postgres "${config.services.postgresql.package}/bin/psql" -c "CREATE EXTENSION unaccent;" ${cfg.database.name}

            touch "${cfg.runtimeDir}/.first_run"
            rm "${cfg.runtimeDir}/.first_run_partial"
          fi
        '';
        in "+${script}";
      };

      unitConfig.RequiresMountsFor = cfg.runtimeDir;
    };
  };
}

