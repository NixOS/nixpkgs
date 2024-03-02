{ config, pkgs, lib, ... }:

let
  cfg = config.services.windmill;
in
{
  options.services.windmill = {
    enable = lib.mkEnableOption (lib.mdDoc "windmill service");

    serverPort = lib.mkOption {
      type = lib.types.port;
      default = 8001;
      description = lib.mdDoc "Port the windmill server listens on.";
    };

    lspPort = lib.mkOption {
      type = lib.types.port;
      default = 3001;
      description = lib.mdDoc "Port the windmill lsp listens on.";
    };

    database = {
      name = lib.mkOption {
        type = lib.types.str;
        # the simplest database setup is to have the database named like the user.
        default = "windmill";
        description = lib.mdDoc "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        # the simplest database setup is to have the database user like the name.
        default = "windmill";
        description = lib.mdDoc "Database user.";
      };

      urlPath = lib.mkOption {
        type = lib.types.path;
        description = lib.mdDoc ''
          Path to the file containing the database url windmill should connect to. This is not deducted from database user and name as it might contain a secret
        '';
        example = "config.age.secrets.DATABASE_URL_FILE.path";
      };
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc "Whether to create a local database automatically.";
      };
    };

    baseUrl = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc ''
        The base url that windmill will be served on.
      '';
      example = "https://windmill.example.com";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [ "error" "warn" "info" "debug" "trace" ];
      default = "info";
      description = lib.mdDoc "Log level";
    };
  };

  config = lib.mkIf cfg.enable {

    services.postgresql = lib.optionalAttrs (cfg.database.createLocally) {
      enable = lib.mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];

   };

   systemd.services =
    let
      serviceConfig = {
        DynamicUser = true;
        # using the same user to simplify db connection
        User = cfg.database.user;
        ExecStart = "${pkgs.windmill}/bin/windmill";

        Restart = "always";
        LoadCredential = [
          "DATABASE_URL_FILE:${cfg.database.urlPath}"
        ];
      };
    in
    {

    # coming from https://github.com/windmill-labs/windmill/blob/main/init-db-as-superuser.sql
    # modified to not grant priviledges on all tables
    # create role windmill_user and windmill_admin only if they don't exist
    postgresql.postStart = lib.mkIf cfg.database.createLocally (lib.mkAfter ''
      $PSQL -tA <<"EOF"
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
    GRANT windmill_admin TO windmill;
END
$$;
EOF
    '');

     windmill-server = {
        description = "Windmill server";
        after = [ "network.target" ] ++ lib.optional cfg.database.createLocally "postgresql.service";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = serviceConfig // { StateDirectory = "windmill";};

        environment = {
          DATABASE_URL_FILE = "%d/DATABASE_URL_FILE";
          PORT = builtins.toString cfg.serverPort;
          WM_BASE_URL = cfg.baseUrl;
          RUST_LOG = cfg.logLevel;
          MODE = "server";
        };
      };

     windmill-worker = {
        description = "Windmill worker";
        after = [ "network.target" ] ++ lib.optional cfg.database.createLocally "postgresql.service";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = serviceConfig // { StateDirectory = "windmill-worker";};

        environment = {
          DATABASE_URL_FILE = "%d/DATABASE_URL_FILE";
          WM_BASE_URL = cfg.baseUrl;
          RUST_LOG = cfg.logLevel;
          MODE = "worker";
          WORKER_GROUP = "default";
          KEEP_JOB_DIR = "false";
        };
      };

     windmill-worker-native = {
        description = "Windmill worker native";
        after = [ "network.target" ] ++ lib.optional cfg.database.createLocally "postgresql.service";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = serviceConfig // { StateDirectory = "windmill-worker-native";};

        environment = {
          DATABASE_URL_FILE = "%d/DATABASE_URL_FILE";
          WM_BASE_URL = cfg.baseUrl;
          RUST_LOG = cfg.logLevel;
          MODE = "worker";
          WORKER_GROUP = "native";
        };
      };
    };
  };
}
