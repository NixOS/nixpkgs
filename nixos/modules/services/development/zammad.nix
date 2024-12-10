{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.zammad;
  settingsFormat = pkgs.formats.yaml { };
  filterNull = filterAttrs (_: v: v != null);
  serviceConfig = {
    Type = "simple";
    Restart = "always";

    User = "zammad";
    Group = "zammad";
    PrivateTmp = true;
    StateDirectory = "zammad";
    WorkingDirectory = cfg.dataDir;
  };
  environment = {
    RAILS_ENV = "production";
    NODE_ENV = "production";
    RAILS_SERVE_STATIC_FILES = "true";
    RAILS_LOG_TO_STDOUT = "true";
    REDIS_URL = "redis://${cfg.redis.host}:${toString cfg.redis.port}";
  };
  databaseConfig = settingsFormat.generate "database.yml" cfg.database.settings;
in
{

  options = {
    services.zammad = {
      enable = mkEnableOption "Zammad, a web-based, open source user support/ticketing solution";

      package = mkPackageOption pkgs "zammad" { };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/zammad";
        description = ''
          Path to a folder that will contain Zammad working directory.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "192.168.23.42";
        description = "Host address.";
      };

      openPorts = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open firewall ports for Zammad";
      };

      port = mkOption {
        type = types.port;
        default = 3000;
        description = "Web service port.";
      };

      websocketPort = mkOption {
        type = types.port;
        default = 6042;
        description = "Websocket service port.";
      };

      redis = {
        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to create a local redis automatically.";
        };

        name = mkOption {
          type = types.str;
          default = "zammad";
          description = ''
            Name of the redis server. Only used if `createLocally` is set to true.
          '';
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            Redis server address.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 6379;
          description = "Port of the redis server.";
        };
      };

      database = {
        type = mkOption {
          type = types.enum [
            "PostgreSQL"
            "MySQL"
          ];
          default = "PostgreSQL";
          example = "MySQL";
          description = "Database engine to use.";
        };

        host = mkOption {
          type = types.nullOr types.str;
          default =
            {
              PostgreSQL = "/run/postgresql";
              MySQL = "localhost";
            }
            .${cfg.database.type};
          defaultText = literalExpression ''
            {
              PostgreSQL = "/run/postgresql";
              MySQL = "localhost";
            }.''${config.services.zammad.database.type};
          '';
          description = ''
            Database host address.
          '';
        };

        port = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = "Database port. Use `null` for default port.";
        };

        name = mkOption {
          type = types.str;
          default = "zammad";
          description = ''
            Database name.
          '';
        };

        user = mkOption {
          type = types.nullOr types.str;
          default = "zammad";
          description = "Database user.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/zammad-dbpassword";
          description = ''
            A file containing the password for {option}`services.zammad.database.user`.
          '';
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
        };

        settings = mkOption {
          type = settingsFormat.type;
          default = { };
          example = literalExpression ''
            {
            }
          '';
          description = ''
            The {file}`database.yml` configuration file as key value set.
            See \<TODO\>
            for list of configuration parameters.
          '';
        };
      };

      secretKeyBaseFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/secret_key_base";
        description = ''
          The path to a file containing the
          `secret_key_base` secret.

          Zammad uses `secret_key_base` to encrypt
          the cookie store, which contains session data, and to digest
          user auth tokens.

          Needs to be a 64 byte long string of hexadecimal
          characters. You can generate one by running

          ```
          openssl rand -hex 64 >/path/to/secret_key_base_file
          ```

          This should be a string, not a nix path, since nix paths are
          copied into the world-readable nix store.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.zammad.database.settings = {
      production = mapAttrs (_: v: mkDefault v) (filterNull {
        adapter =
          {
            PostgreSQL = "postgresql";
            MySQL = "mysql2";
          }
          .${cfg.database.type};
        database = cfg.database.name;
        pool = 50;
        timeout = 5000;
        encoding = "utf8";
        username = cfg.database.user;
        host = cfg.database.host;
        port = cfg.database.port;
      });
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openPorts [
      config.services.zammad.port
      config.services.zammad.websocketPort
    ];

    users.users.zammad = {
      isSystemUser = true;
      home = cfg.dataDir;
      group = "zammad";
    };

    users.groups.zammad = { };

    assertions = [
      {
        assertion =
          cfg.database.createLocally -> cfg.database.user == "zammad" && cfg.database.name == "zammad";
        message = "services.zammad.database.user must be set to \"zammad\" if services.zammad.database.createLocally is set to true";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.zammad.database.createLocally is set to true";
      }
      {
        assertion = cfg.redis.createLocally -> cfg.redis.host == "localhost";
        message = "the redis host must be localhost if services.zammad.redis.createLocally is set to true";
      }
    ];

    services.mysql = optionalAttrs (cfg.database.createLocally && cfg.database.type == "MySQL") {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.postgresql =
      optionalAttrs (cfg.database.createLocally && cfg.database.type == "PostgreSQL")
        {
          enable = true;
          ensureDatabases = [ cfg.database.name ];
          ensureUsers = [
            {
              name = cfg.database.user;
              ensureDBOwnership = true;
            }
          ];
        };

    services.redis = optionalAttrs cfg.redis.createLocally {
      servers."${cfg.redis.name}" = {
        enable = true;
        port = cfg.redis.port;
      };
    };

    systemd.services.zammad-web = {
      inherit environment;
      serviceConfig = serviceConfig // {
        # loading all the gems takes time
        TimeoutStartSec = 1200;
      };
      after =
        [
          "network.target"
          "postgresql.service"
        ]
        ++ optionals cfg.redis.createLocally [
          "redis-${cfg.redis.name}.service"
        ];
      requires = [
        "postgresql.service"
      ];
      description = "Zammad web";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        # Blindly copy the whole project here.
        chmod -R +w .
        rm -rf ./public/assets/
        rm -rf ./tmp/*
        rm -rf ./log/*
        cp -r --no-preserve=owner ${cfg.package}/* .
        chmod -R +w .
        # config file
        cp ${databaseConfig} ./config/database.yml
        chmod -R +w .
        ${optionalString (cfg.database.passwordFile != null) ''
          {
            echo -n "  password: "
            cat ${cfg.database.passwordFile}
          } >> ./config/database.yml
        ''}
        ${optionalString (cfg.secretKeyBaseFile != null) ''
          {
            echo "production: "
            echo -n "  secret_key_base: "
            cat ${cfg.secretKeyBaseFile}
          } > ./config/secrets.yml
        ''}

        if [ `${config.services.postgresql.package}/bin/psql \
                  --host ${cfg.database.host} \
                  ${optionalString (cfg.database.port != null) "--port ${toString cfg.database.port}"} \
                  --username ${cfg.database.user} \
                  --dbname ${cfg.database.name} \
                  --command "SELECT COUNT(*) FROM pg_class c \
                            JOIN pg_namespace s ON s.oid = c.relnamespace \
                            WHERE s.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema') \
                              AND s.nspname NOT LIKE 'pg_temp%';" | sed -n 3p` -eq 0 ]; then
          echo "Initialize database"
          ./bin/rake --no-system db:migrate
          ./bin/rake --no-system db:seed
        else
          echo "Migrate database"
          ./bin/rake --no-system db:migrate
        fi
        echo "Done"
      '';
      script = "./script/rails server -b ${cfg.host} -p ${toString cfg.port}";
    };

    systemd.services.zammad-websocket = {
      inherit serviceConfig environment;
      after = [ "zammad-web.service" ];
      requires = [ "zammad-web.service" ];
      description = "Zammad websocket";
      wantedBy = [ "multi-user.target" ];
      script = "./script/websocket-server.rb -b ${cfg.host} -p ${toString cfg.websocketPort} start";
    };

    systemd.services.zammad-worker = {
      inherit serviceConfig environment;
      after = [ "zammad-web.service" ];
      requires = [ "zammad-web.service" ];
      description = "Zammad background worker";
      wantedBy = [ "multi-user.target" ];
      script = "./script/background-worker.rb start";
    };
  };

  meta.maintainers = with lib.maintainers; [
    taeer
    netali
  ];
}
