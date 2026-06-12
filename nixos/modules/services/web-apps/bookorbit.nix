{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.bookorbit;

  databaseUrl = "postgresql:///${cfg.database.name}?host=/run/postgresql&user=${cfg.database.user}";

  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  package = getExe pkgs.bookorbit;

  postgresqlPackage = config.services.postgresql.package;
in
{
  options.services.bookorbit = {
    enable = mkEnableOption "BookOrbit";

    user = mkOption {
      type = types.str;
      default = "bookorbit";
      description = "User account under which BookOrbit runs.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the appropriate ports in the firewall for BookOrbit.";
    };

    bookPath = mkOption {
      type = types.path;
      description = "Path where books are stored.";
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };

      name = mkOption {
        type = types.str;
        default = "bookorbit";
        description = "Database name.";
      };

      user = mkOption {
        type = types.str;
        default = "bookorbit";
        description = "Database user.";
      };
    };

    environment = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf types.str;
        options = {
          APP_DATA_PATH = mkOption {
            type = types.str;
            default = "/var/lib/bookorbit";
            description = "Data storage directory.";
          };
          PORT = mkOption {
            type = types.port;
            default = 3000;
            apply = toString;
            description = "TCP port for the BookOrbit server.";
          };
          # TODO: use path to file
          JWT_SECRET = mkOption {
            type = types.str;
            description = "";
          };
          # TODO: use path to file
          SETUP_BOOTSTRAP_TOKEN = mkOption {
            type = types.str;
            example = "";
            description = "";
          };
        };
      };
      default = { };
      example = {
        JWT_SECRET = "change-me";
        SETUP_BOOTSTRAP_TOKEN = "change-me";
      };
      description = ''
        Environment variables to pass to the BookOrbit service.
        See <https://bookorbit.app/installation.html#configuration> for available options.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      example = "/run/secrets/bookorbit";
      default = null;
      description = ''
        Path of a file with extra environment variables to be loaded from disk.
        This file is not added to the nix store, so it can be used to pass secrets to BookOrbit.
        See <https://bookorbit.app/installation.html#configuration> for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services = {
      bookorbit = {
        description = "BookOrbit";
        after = [
          "network-online.target"
          "postgresql.service"
          "bookorbit-migrate.service"
        ];
        requires = [ "bookorbit-migrate.service" ];
        wants = [
          "network-online.target"
          "postgresql.service"
        ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          DATABASE_URL = databaseUrl;
        }
        // cfg.environment;
        serviceConfig = {
          DynamicUser = true;
          User = cfg.user;
          ExecStart = package;
          StateDirectory = "bookorbit";
          EnvironmentFile = cfg.environmentFile;

          BindPaths = "${cfg.bookPath}:/books/";

          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateMounts = true;
          ProtectControlGroups = true;
          ProtectKernelTunables = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          UMask = "0077";

          CapabilityBoundingSet = [ "" ];
          NoNewPrivileges = true;

          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];

          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
            "AF_NETLINK"
          ];

          PrivateUsers = true;

          LockPersonality = true;
          ProtectHostname = true;
          RestrictRealtime = true;
          RestrictNamespaces = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          DeviceAllow = [ "" ];
        };
      };

      postgresql-setup.serviceConfig.ExecStartPost =
        let
          extensions = [
            "uuid-ossp"
            "pg_trgm"
            "vector"
          ];
          sqlFile = pkgs.writeText "bookorbit-pgext-setup.sql" ''
            ${lib.concatMapStringsSep "\n" (ext: "CREATE EXTENSION IF NOT EXISTS \"${ext}\";") extensions}
          '';
        in
        [
          ''
            ${lib.getExe' postgresqlPackage "psql"} -d "${cfg.database.name}" -f "${sqlFile}"
          ''
        ];

      bookorbit-migrate = {
        description = "BookOrbit database migration";
        after = [ "postgresql.service" ];
        wants = [ "postgresql.service" ];

        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          User = cfg.user;

          ExecStart = "${pkgs.bookorbit}/bin/bookorbit-migrate";
        };

        environment = {
          DATABASE_URL = databaseUrl;
        }
        // cfg.environment;
      };
    };

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;

      extensions = ps: with ps; [ pgvector ];

      ensureDatabases = [ cfg.database.name ];

      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.environment.PORT ];
  };

  meta = {
    maintainers = with lib.maintainers; [ iv-nn ];
  };
}
