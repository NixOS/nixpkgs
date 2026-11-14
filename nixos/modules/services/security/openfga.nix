{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optional
    types
    ;

  cfg = config.services.openfga;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "openfga-config.yaml" (
    lib.filterAttrsRecursive (_: v: v != null) cfg.settings
  );

  engine = cfg.settings.datastore.engine;
  localPostgres = cfg.database.createLocally && engine == "postgres";
  localMysql = cfg.database.createLocally && engine == "mysql";

  mkAddrOption =
    default: description:
    mkOption {
      type = types.str;
      inherit default description;
    };
in
{
  meta.maintainers = pkgs.openfga.meta.maintainers;

  options.services.openfga = {
    enable = mkEnableOption "OpenFGA, an authorization server inspired by Google Zanzibar";

    package = mkPackageOption pkgs "openfga" { };

    settings = mkOption {
      default = { };
      description = ''
        Configuration for OpenFGA, written to {file}`/etc/openfga/config.yaml`.
        See <https://openfga.dev/docs/getting-started/setup-openfga/configuration> for the available options.
      '';
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          datastore = mkOption {
            default = { };
            description = "Datastore configuration.";
            type = types.submodule {
              freeformType = settingsFormat.type;

              options = {
                engine = mkOption {
                  type = types.enum [
                    "memory"
                    "postgres"
                    "mysql"
                    "sqlite"
                  ];
                  default = "memory";
                  description = "Datastore engine.";
                };

                uri = mkOption {
                  type = types.nullOr types.str;
                  default =
                    if localPostgres then
                      "postgres:///openfga?host=/run/postgresql"
                    else if localMysql then
                      "openfga@unix(/run/mysqld/mysqld.sock)/openfga?parseTime=true"
                    else if engine == "sqlite" then
                      "file:/var/lib/openfga/openfga.db"
                    else
                      null;
                  defaultText = lib.literalMD ''
                    `"file:/var/lib/openfga/openfga.db"` for `sqlite`, the local database's Unix socket when {option}`services.openfga.database.createLocally` is enabled, and `null` otherwise
                  '';
                  example = "postgres://openfga@db.example.com:5432/openfga";
                  description = "Connection URI for the datastore, required for every engine other than `memory`.";
                };
              };
            };
          };

          http = mkOption {
            default = { };
            description = "HTTP server configuration.";
            type = types.submodule {
              freeformType = settingsFormat.type;
              options.addr = mkAddrOption "127.0.0.1:8080" "Address the HTTP server listens on.";
            };
          };

          grpc = mkOption {
            default = { };
            description = "gRPC server configuration.";
            type = types.submodule {
              freeformType = settingsFormat.type;
              options.addr = mkAddrOption "127.0.0.1:8081" "Address the gRPC server listens on.";
            };
          };

          metrics = mkOption {
            default = { };
            description = "Prometheus metrics configuration.";
            type = types.submodule {
              freeformType = settingsFormat.type;
              options.addr = mkAddrOption "127.0.0.1:2112" "Address the metrics server listens on.";
            };
          };
        };
      };
    };

    database.createLocally = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to create a local PostgreSQL or MySQL database and user named `openfga`, which OpenFGA connects to over a Unix socket.
        With `mysql`, {option}`services.mysql.package` has to be MySQL, since OpenFGA's migrations fail on MariaDB.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/openfga.env";
      description = ''
        Environment file for passing secrets as the environment variables listed in <https://openfga.dev/docs/getting-started/setup-openfga/configuration>.
        Variables set in it take precedence over {option}`services.openfga.settings`.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = engine == "memory" || cfg.settings.datastore.uri != null;
          message = "services.openfga.settings.datastore.uri must be set when the engine is ${engine}.";
        }
        {
          assertion = cfg.database.createLocally -> localPostgres || localMysql;
          message = "services.openfga.database.createLocally only supports the postgres and mysql engines.";
        }
        {
          assertion = localMysql -> lib.getName config.services.mysql.package != lib.getName pkgs.mariadb;
          message = "services.openfga.database.createLocally needs services.mysql.package to be MySQL, since OpenFGA's migrations fail on MariaDB.";
        }
      ];

      environment.etc."openfga/config.yaml".source = configFile;

      systemd.services.openfga = {
        description = "OpenFGA authorization server";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [
          "network-online.target"
        ]
        ++ optional localPostgres "postgresql.target"
        ++ optional localMysql "mysql.service";
        requires = optional localPostgres "postgresql.target" ++ optional localMysql "mysql.service";
        restartTriggers = [ configFile ];

        serviceConfig = {
          ExecStartPre = mkIf (engine != "memory") "${getExe cfg.package} migrate";
          ExecStart = "${getExe cfg.package} run";
          EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
          Restart = "on-failure";

          DynamicUser = true;
          User = "openfga";
          StateDirectory = "openfga";
          UMask = "0077";

          CapabilityBoundingSet = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
        };
      };
    }

    (mkIf localPostgres {
      services.postgresql = {
        enable = true;
        ensureDatabases = [ "openfga" ];
        ensureUsers = [
          {
            name = "openfga";
            ensureDBOwnership = true;
          }
        ];
      };
    })

    (mkIf localMysql {
      services.mysql = {
        enable = true;
        ensureDatabases = [ "openfga" ];
        ensureUsers = [
          {
            name = "openfga";
            ensurePermissions."openfga.*" = "ALL PRIVILEGES";
          }
        ];
      };
    })
  ]);
}
