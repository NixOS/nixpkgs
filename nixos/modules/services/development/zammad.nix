{ config, lib, pkgs, ... }:

let
  cfg = config.services.zammad;
  serviceConfig = {
    Type = "simple";
    Restart = "always";

    User = "zammad";
    Group = "zammad";
    PrivateTmp = true;
    StateDirectory = builtins.baseNameOf cfg.dataDir;
    WorkingDirectory = cfg.dataDir;

    EnvironmentFile = cfg.secretsFile;
  };
  env = {
    RAILS_ENV = "production";
    NODE_ENV = "production";
    RAILS_SERVE_STATIC_FILES="true";
    RAILS_LOG_TO_STDOUT="true";
  };
in {

  options = {
    services.zammad = {
      enable = lib.mkEnableOption "Zammad, a web-based, open source user support/ticketing solution.";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.zammad;
        defaultText = "pkgs.zammad";
        description = "Zammad package to use.";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/zammad";
        description = ''
          Path to a folder that will contain Zammad working directory.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        example = "192.168.23.42";
        description = "Host address.";
      };

      port = lib.mkOption {
        type = lib.types.int;
        default = 3000;
        description = "Web service port.";
      };

      websocketPort = lib.mkOption {
        type = lib.types.int;
        default = 6042;
        description = "Websocket service port.";
      };

      dbName = lib.mkOption {
        type = lib.types.str;
        default = "zammad";
        description = "The name of the database to use.";
      };

      dbUsername = lib.mkOption {
        type = lib.types.str;
        default = "zammad";
        description = "The username to use to connect to the database.";
      };

      secretsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path of a file containing secrets the format of EnvironmentFile as
          described by systemd.exec(5). You must to define:
            - PGPASSWORD
            - SECRET_KEY_BASE
          SECRET_KEY_BASE can be generated using:
            ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = [
      config.services.zammad.port
      config.services.zammad.websocketPort
    ];

    users.users.zammad = {
      isSystemUser = true;
      home = cfg.dataDir;
      group = "zammad";
    };

    users.groups.zammad = {};

    services.postgresql = {
      enable = true;
      ensureDatabases = [ cfg.dbName ];
      ensureUsers = [
        {
          name = cfg.dbUsername;
          ensurePermissions."DATABASE ${cfg.dbName}" = "ALL PRIVILEGES";
        }
      ];
    };

    systemd.services.zammad-setup = {
      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
      serviceConfig.EnvironmentFile = cfg.secretsFile;
      script = ''
        echo "Setting password for database '${cfg.dbName}' and user '${cfg.dbUsername}'"
        ${pkgs.util-linux}/bin/runuser -u ${config.services.postgresql.superUser} -- \
          ${config.services.postgresql.package}/bin/psql \
            -c "ALTER ROLE ${cfg.dbUsername} WITH PASSWORD '$PGPASSWORD'"
        mkdir -p ${cfg.dataDir}
      '';
    };

    systemd.services.zammad-web = {
      after = [
        "network.target"
        "postgresql.service"
        "zammad-setup.service"
      ];
      requires = [
        "postgresql.service"
        "zammad-setup.service"
      ];
      description = "Zammad web";
      wantedBy = [ "multi-user.target" ];
      environment = env;
      preStart = ''
        # Blindly copy the whole project here.
        chmod -R +w ${cfg.dataDir}/
        rm -rf ${cfg.dataDir}/public/assets/*
        rm -rf ${cfg.dataDir}/tmp/*
        rm -rf ${cfg.dataDir}/log/*
        cp -r --no-preserve=owner ${cfg.package}/* ${cfg.dataDir}
        chmod -R +w ${cfg.dataDir}
        export DATABASE_URL="postgresql://${cfg.dbUsername}:$PGPASSWORD@localhost:${toString(config.services.postgresql.port)}/${cfg.dbName}";
        if [ `${config.services.postgresql.package}/bin/psql \
                  --host localhost \
                  --port ${toString(config.services.postgresql.port)} \
                  --username ${cfg.dbUsername} \
                  --dbname ${cfg.dbName} \
                  --command "SELECT COUNT(*) FROM pg_class c \
                            JOIN pg_namespace s ON s.oid = c.relnamespace \
                            WHERE s.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema') \
                              AND s.nspname NOT LIKE 'pg_temp%';" | sed -n 3p` -eq 0 ]; then
          echo "Initialize database"
          ${cfg.dataDir}/bin/rake db:migrate
          ${cfg.dataDir}/bin/rake db:seed
        else
          echo "Migrate database"
          ${cfg.dataDir}/bin/rake db:migrate
        fi
        echo "Done"
      '';

      serviceConfig = serviceConfig // {
        ExecStart = pkgs.writeShellScript "zammad-web-start" ''
          set -eu
          export DATABASE_URL="postgresql://${cfg.dbUsername}:$PGPASSWORD@localhost:${toString(config.services.postgresql.port)}/${cfg.dbName}"
          ${cfg.dataDir}/script/rails server -b ${cfg.host} -p ${toString(cfg.port)}
        '';
      };
    };

    systemd.services.zammad-websocket = {
      after = [ "zammad-web.service" ];
      requires = [
        "zammad-web.service"
      ];
      description = "Zammad websocket";
      wantedBy = [ "multi-user.target" ];
      environment = env;
      serviceConfig = serviceConfig // {
        ExecStart = pkgs.writeShellScript "zammad-websocket-start" ''
          set -eu
          export DATABASE_URL="postgresql://${cfg.dbUsername}:$PGPASSWORD@localhost:${toString(config.services.postgresql.port)}/${cfg.dbName}"
          ${cfg.dataDir}/script/websocket-server.rb -b ${cfg.host} -p ${toString(cfg.websocketPort)} start
        '';
      };
    };

    systemd.services.zammad-scheduler = {
      after = [ "zammad-web.service" ];
      requires = [
        "zammad-web.service"
      ];
      description = "Zammad scheduler";
      wantedBy = [ "multi-user.target" ];
      environment = env;
      serviceConfig = serviceConfig // {
        Type = "forking";
        ExecStart = pkgs.writeShellScript "zammad-scheduler-start" ''
          set -eu
          export DATABASE_URL="postgresql://${cfg.dbUsername}:$PGPASSWORD@localhost:${toString(config.services.postgresql.port)}/${cfg.dbName}"
          ${cfg.dataDir}/script/scheduler.rb start
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ garbas ];
}
