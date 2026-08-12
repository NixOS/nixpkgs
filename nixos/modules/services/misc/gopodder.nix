{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.gopodder;

  usePostgres = cfg.database.type == "postgres";
in
{
  options.services.gopodder = {
    enable = mkEnableOption "Gopodder, podcast synchronization server";

    package = mkPackageOption pkgs "gopodder" { };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "127.0.0.1";
      description = "Host address Gopodder binds to.";
    };

    debugHost = mkOption {
      type = types.str;
      default = "";
      example = "";
      description = "Listen address for debug/metrics (disabled if empty).";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      example = 4242;
      description = "TCP port Gopodder host will listen on.";
    };

    logLevel = mkOption {
      type = types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      example = "debug";
      description = "Log level (debug, info, warn, error)";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to file containing runtime secrets, such as `GOPODDER_DB_PASSWORD`";
      example = "/run/secrets/gopodder.env";
    };

    database = {
      type = mkOption {
        type = types.enum [
          "sqlite"
          "postgres"
        ];
        default = "sqlite";
        description = "Database type to use";
      };

      host = mkOption {
        type = types.str;
        default = "";
        description = "PostgreSQL host";
      };

      port = mkOption {
        type = types.port;
        default = 5432;
        description = "PostgreSQL port";
      };

      name = mkOption {
        type = types.str;
        default = "gopodder";
        description = "PostgreSQL database name";
      };

      user = mkOption {
        type = types.str;
        default = "gopodder";
        description = "PostgreSQL user";
      };

      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to create a local PostgreSQL database automatically";
      };
    };

    user = mkOption {
      type = types.str;
      default = "gopodder";
      description = "User account under which Gopodder runs";
    };

    group = mkOption {
      type = types.str;
      default = "gopodder";
      description = "Group under which Gopodder runs";
    };

    openFirewall = mkOption {
      description = "Open ports in the firewall for the Gopodder web interface.";
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createLocally -> usePostgres;
        message = "services.gopodder.database.createLocally is enabled but not database.type is not postgres";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.host == "";
        message = "services.gopodder.database.host must be empty when services.gopodder.database.createLocally is enabled";
      }
      {
        assertion =
          cfg.database.createLocally
          -> cfg.database.user == cfg.user && cfg.database.user == cfg.database.name;
        message = "specifying services.gopodder.database.user should be the same as services.gopodder.user as well as services.gopodder.database.name when running a local db setup";
      }
      {
        assertion = (usePostgres && !cfg.database.createLocally) -> cfg.environmentFile != null;
        message = "specifying services.gopodder.environmentFile is not supported when used along with a local db setup";
      }
    ];

    services.postgresql = mkIf (cfg.database.createLocally) {
      enable = true;
      ensureUsers = [
        {
          name = "${cfg.database.user}";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ cfg.database.name ];
    };

    systemd.services.gopodder = {
      description = "Gopodder podcast synchronization server";
      wantedBy = [ "multi-user.target" ];
      requires = optionals cfg.database.createLocally [
        "postgresql.target"
      ];
      after = [
        "network.target"
      ]
      ++ optionals cfg.database.createLocally [
        "postgresql.target"
      ];
      environment = {
        GOPODDER_LISTEN_ADDRESS = cfg.host + ":" + toString cfg.port;
        GOPODDER_DEBUG_ADDRESS = cfg.debugHost;
        GOPODDER_DB_BACKEND = cfg.database.type;
        GOPODDER_LOG_LEVEL = cfg.logLevel;
        GOPODDER_DB_PATH = mkIf (!usePostgres) "gopodder.db";
      }
      // optionalAttrs (cfg.database.createLocally) {
        GOPODDER_DB_POSTGRES =
          if cfg.database.host == "" then
            "host=/run/postgresql dbname=${cfg.database.name} user=${cfg.database.user}"
          else
            "host=${cfg.database.host} port=${toString cfg.database.port} dbname=${cfg.database.name} user=${cfg.database.user}";
      };
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/gopodder serve";
        WorkingDirectory = "/var/lib/gopodder";
        StateDirectory = "gopodder";
        StateDirectoryMode = "0700";
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = { };
  };

  meta.maintainers = with maintainers; [ nielmin ];
}
