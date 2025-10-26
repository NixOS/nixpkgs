{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.windmill;
in
{
  options.services.windmill = {
    enable = lib.mkEnableOption "windmill service";

    package = lib.mkPackageOption pkgs "windmill" { };

    serverPort = lib.mkOption {
      type = lib.types.port;
      default = 8001;
      description = "Port the windmill server listens on.";
    };

    lspPort = lib.mkOption {
      type = lib.types.port;
      default = 3001;
      description = "Port the windmill lsp listens on.";
    };

    database = {
      name = lib.mkOption {
        type = lib.types.str;
        # the simplest database setup is to have the database named like the user.
        default = "windmill";
        description = "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        # the simplest database setup is to have the database user like the name.
        default = "windmill";
        description = "Database user.";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "postgres://${config.services.windmill.database.name}?host=/var/run/postgresql";
        defaultText = lib.literalExpression ''
          "postgres://\$\{config.services.windmill.database.name}?host=/var/run/postgresql";
        '';
        description = "Database url. Note that any secret here would be world-readable. Use `services.windmill.database.urlPath` unstead to include secrets in the url.";
      };

      urlPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        description = ''
          Path to the file containing the database url windmill should connect to. This is not deducted from database user and name as it might contain a secret
        '';
        default = null;
        example = "config.age.secrets.DATABASE_URL_FILE.path";
      };

      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to create a local database automatically.";
      };
    };

    baseUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://localhost:${toString config.services.windmill.serverPort}";
      defaultText = lib.literalExpression ''
        "https://localhost:\$\{toString config.services.windmill.serverPort}";
      '';
      description = ''
        The base url that windmill will be served on.
      '';
      example = "https://windmill.example.com";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "error"
        "warn"
        "info"
        "debug"
        "trace"
      ];
      default = "info";
      description = "Log level";
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.name == cfg.database.user;
        message = ''
          Automatically provisioning the windmill database requires both database name and database user to be equal. '${cfg.database.name}' != '${cfg.database.user}'
          To fix this problem, assign the same value to both options services.windmill.database.{name,user}.
        '';
      }
    ];

    services.postgresql = lib.optionalAttrs (cfg.database.createLocally) {
      enable = lib.mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.targets.windmill = {
      description = "Windmill";
      wantedBy = [ "multi-user.target" ];
      requires =
        [ ]
        ++ (lib.optionals config.systemd.services.windmill-server.enable [ "windmill-server.service" ])
        ++ (lib.optionals config.systemd.services.windmill-worker.enable [ "windmill-worker.service" ])
        ++ (lib.optionals config.systemd.services.windmill-worker-native.enable [
          "windmill-worker-native.service"
        ]);
    };

    systemd.services =
      let
        useUrlPath = (cfg.database.urlPath != null);
        serviceConfig = {
          DynamicUser = true;
          # using the same user to simplify db connection
          User = cfg.database.user;
          ExecStart = lib.getExe cfg.package;
          Restart = "always";
        }
        // lib.optionalAttrs useUrlPath {
          LoadCredential = [
            "DATABASE_URL_FILE:${cfg.database.urlPath}"
          ];
        };
        db_url_envs =
          lib.optionalAttrs useUrlPath {
            DATABASE_URL_FILE = "%d/DATABASE_URL_FILE";
          }
          // lib.optionalAttrs (!useUrlPath) {
            DATABASE_URL = cfg.database.url;
          };
      in
      {
        windmill-initdb = lib.mkIf cfg.database.createLocally {
          description = "Windmill database setup";
          requires = [ "postgresql.target" ];
          after = [ "postgresql.target" ];
          requiredBy =
            [ ]
            ++ (lib.optionals config.systemd.services.windmill-server.enable [ "windmill-server.service" ])
            ++ (lib.optionals config.systemd.services.windmill-worker.enable [ "windmill-worker.service" ])
            ++ (lib.optionals config.systemd.services.windmill-worker-native.enable [
              "windmill-worker-native.service"
            ]);
          before =
            [ ]
            ++ (lib.optionals config.systemd.services.windmill-server.enable [ "windmill-server.service" ])
            ++ (lib.optionals config.systemd.services.windmill-worker.enable [ "windmill-worker.service" ])
            ++ (lib.optionals config.systemd.services.windmill-worker-native.enable [
              "windmill-worker-native.service"
            ]);

          path = [ config.services.postgresql.package ];
          # coming from https://github.com/windmill-labs/windmill/blob/main/init-db-as-superuser.sql
          # modified to not grant privileges on all tables
          # create role windmill_user and windmill_admin only if they don't exist
          script = ''
            psql -tA <<"EOF"
              DO $$
              BEGIN
                  IF NOT EXISTS (
                      SELECT FROM pg_catalog.pg_roles
                      WHERE rolname = 'windmill_user'
                  ) THEN
                      CREATE ROLE windmill_user;
                      GRANT ALL PRIVILEGES ON DATABASE ${cfg.database.name} TO windmill_user;
                  ELSE
                    RAISE NOTICE 'Role "windmill_user" already exists. Skipping.';
                  END IF;
                  IF NOT EXISTS (
                      SELECT FROM pg_catalog.pg_roles
                      WHERE rolname = 'windmill_admin'
                  ) THEN
                    CREATE ROLE windmill_admin WITH BYPASSRLS;
                    GRANT windmill_user TO windmill_admin;
                  ELSE
                    RAISE NOTICE 'Role "windmill_admin" already exists. Skipping.';
                  END IF;
                  GRANT windmill_admin TO ${cfg.database.user};
              END
              $$;
            EOF
          '';

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            # Superuser because of required permission CREATE ROLE
            User = "postgres";

            ProtectSystem = "strict";
            ProtectHome = "read-only";
          };
        };

        windmill-server = {
          description = "Windmill server";
          after = [ "network.target" ];
          partOf = [ "windmill.target" ];

          serviceConfig = serviceConfig // {
            StateDirectory = "windmill";
          };

          environment = {
            PORT = builtins.toString cfg.serverPort;
            WM_BASE_URL = cfg.baseUrl;
            RUST_LOG = cfg.logLevel;
            MODE = "server";
          }
          // db_url_envs;
        };

        windmill-worker = {
          description = "Windmill worker";
          after = [ "network.target" ];
          partOf = [ "windmill.target" ];

          serviceConfig = serviceConfig // {
            StateDirectory = "windmill-worker";
          };

          environment = {
            WM_BASE_URL = cfg.baseUrl;
            RUST_LOG = cfg.logLevel;
            MODE = "worker";
            WORKER_GROUP = "default";
            KEEP_JOB_DIR = "false";
          }
          // db_url_envs;
        };

        windmill-worker-native = {
          description = "Windmill worker native";
          after = [ "network.target" ];
          partOf = [ "windmill.target" ];

          serviceConfig = serviceConfig // {
            StateDirectory = "windmill-worker-native";
          };

          environment = {
            WM_BASE_URL = cfg.baseUrl;
            RUST_LOG = cfg.logLevel;
            MODE = "worker";
            WORKER_GROUP = "native";
          }
          // db_url_envs;
        };
      };
  };
}
