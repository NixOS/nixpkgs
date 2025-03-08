{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.prefect;
  inherit (lib.types)
    bool
    str
    enum
    attrsOf
    nullOr
    submodule
    ;

in
{
  options.services.prefect = {
    enable = lib.mkOption {
      type = bool;
      default = false;
      description = "enable prefect server and worker services";
    };

    package = lib.mkPackageOption pkgs "prefect" { };

    database = lib.mkOption {
      type = enum [
        "sqlite"
        "postgres"
      ];
      default = "sqlite";
      description = "which database to use for prefect server: sqlite or postgres";
    };

    databaseHost = lib.mkOption {
      type = str;
      default = "localhost";
      description = "database host for postgres only";
    };

    databasePort = lib.mkOption {
      type = str;
      default = "5432";
      description = "database port for postgres only";
    };

    databaseName = lib.mkOption {
      type = str;
      default = "prefect";
      description = "database name for postgres only";
    };

    databaseUser = lib.mkOption {
      type = str;
      default = "postgres";
      description = "database user for postgres only";
    };

    databasePasswordFile = lib.mkOption {
      type = nullOr str;
      default = null;
      description = ''
        path to a file containing e.g.:
          DBPASSWORD=supersecret

        stored outside the nix store, read by systemd as EnvironmentFile.
      '';
    };

    # now define workerPools as an attribute set of submodules,
    # each key is the pool name, and the submodule has an installPolicy
    workerPools = lib.mkOption {
      type = attrsOf (submodule {
        options = {
          installPolicy = lib.mkOption {
            type = enum [
              "always"
              "if-not-present"
              "never"
              "prompt"
            ];
            default = "always";
            description = "install policy for the worker (always, if-not-present, never, prompt)";
          };
        };
      });
      default = { };
      description = ''
        define a set of worker pools with submodule config. example:
        workerPools.my-pool = {
          installPolicy = "never";
        };
      '';
    };

    baseUrl = lib.mkOption {
      type = nullOr str;
      default = null;
      description = "external url when served by a reverse proxy, e.g. https://example.com/prefect";
    };
  };

  config = lib.mkIf cfg.enable {
    # define systemd.services as the server plus any worker definitions
    systemd.services =
      {
        "prefect-server" = {
          description = "prefect server";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          # environment.systemPackages = [ cfg.package ];

          serviceConfig = {
            DynamicUser = true;
            StateDirectory = "prefect-server";
            Environment =
              let
                sqliteUrl = "sqlite+aiosqlite:///var/lib/prefect-server/prefect.db";
                postgresUrl = "postgresql+asyncpg://${cfg.databaseUser}:$DBPASSWORD@${cfg.databaseHost}:${cfg.databasePort}/${cfg.databaseName};";
                databaseUrl = if cfg.database == "sqlite" then sqliteUrl else postgresUrl;
              in
              [
                "PREFECT_HOME=%S/prefect-server"
                "PREFECT_UI_STATIC_DIRECTORY=%S/prefect-server"
                "PREFECT_SERVER_ANALYTICS_ENABLED=off"
                "PREFECT_UI_API_URL=${cfg.baseUrl}/api"
                "PREFECT_UI_URL=${cfg.baseUrl}"
                "PREFECT_API_DATABASE_CONNECTION_URL=${databaseUrl}"
              ];
            EnvironmentFile =
              if cfg.database == "postgres" && cfg.databasePasswordFile != null then
                [ cfg.databasePasswordFile ]
              else
                [ ];

            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
            MemoryDenyWriteExecute = true;
            LockPersonality = true;
            CapabilityBoundingSet = [ ];
            AmbientCapabilities = [ ];
            RestrictSUIDSGID = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            ReadWritePaths = [ "/var/lib/prefect-server" ];
            MemoryAccounting = true;
            CPUAccounting = true;

            ExecStart = "${pkgs.prefect}/bin/prefect server start";
            Restart = "always";
          };
        };
      }
      // lib.concatMapAttrs (poolName: poolCfg: {
        # return a partial attr set with one key: "prefect-worker-..."
        "prefect-worker-${poolName}" = {
          description = "prefect worker for pool '${poolName}'";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          serviceConfig = {
            DynamicUser = true;
            StateDirectory = "prefect-workers-${poolName}";
            Envitonment = [
              "PREFECT_HOME=%S/prefect-worker-${poolName}"
              "PREFECT_API_URL=${cfg.baseUrl}/api"
            ];
            ProtectSystem = "strict";
            ProtectHome = true;
            PrivateTmp = true;
            NoNewPrivileges = true;
            MemoryDenyWriteExecute = true;
            LockPersonality = true;
            CapabilityBoundingSet = [ ];
            AmbientCapabilities = [ ];
            RestrictSUIDSGID = true;
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            MemoryAccounting = true;
            CPUAccounting = true;
            ExecStart = ''
              ${pkgs.prefect}/bin/prefect worker start \
                --pool ${poolName} \
                --type process \
                --install-policy ${poolCfg.installPolicy}
            '';
            Restart = "always";
          };
        };
      }) cfg.workerPools;
  };
}
