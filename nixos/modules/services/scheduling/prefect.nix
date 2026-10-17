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
    path
    attrsOf
    nullOr
    submodule
    port
    ;

  # `host` is a bind address, and 0.0.0.0 means "every interface" to bind(2)
  # but nothing at all to connect(2). Workers run beside the server, so they
  # dial it directly rather than going back out through `baseUrl` - a reverse
  # proxy that may terminate TLS, require auth, or simply not be up yet.
  localHost = if cfg.host == "0.0.0.0" then "127.0.0.1" else cfg.host;

  # Prefect builds the SQLAlchemy URL itself from these discrete settings, so
  # the password never has to be interpolated into a string that would land in
  # the store. It arrives separately as PREFECT_SERVER_DATABASE_PASSWORD, from
  # `databasePasswordFile`.
  postgresEnvironment = [
    "PREFECT_SERVER_DATABASE_DRIVER=postgresql+asyncpg"
    "PREFECT_SERVER_DATABASE_HOST=${cfg.databaseHost}"
    "PREFECT_SERVER_DATABASE_PORT=${cfg.databasePort}"
    "PREFECT_SERVER_DATABASE_NAME=${cfg.databaseName}"
    "PREFECT_SERVER_DATABASE_USER=${cfg.databaseUser}"
  ];

  # Identical for the server and every worker, so it is written once.
  hardening = {
    DynamicUser = true;
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
  };
in
{
  options.services.prefect = {
    enable = lib.mkOption {
      type = bool;
      default = false;
      description = "enable prefect server and worker services";
    };

    package = lib.mkPackageOption pkgs "prefect" { };

    host = lib.mkOption {
      type = str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "Prefect server host";
    };

    port = lib.mkOption {
      type = port;
      default = 4200;
      description = "Prefect server port";
    };

    dataDir = lib.mkOption {
      type = path;
      default = "/var/lib/prefect-server";
      description = ''
        Working directory for the server. Note that Prefect's own state -
        including the SQLite database - lives in the unit's `StateDirectory`
        rather than here, since the service runs as a `DynamicUser`.
      '';
    };

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
      example = "/run/secrets/prefect-database-password";
      description = ''
        Path to a file containing the postgres password as an environment
        variable assignment:

        ```
        PREFECT_SERVER_DATABASE_PASSWORD=supersecret
        ```

        Stored outside the nix store, read by systemd as an `EnvironmentFile`.

        Leave `null` when postgres authenticates the server some other way,
        such as peer authentication over a unix socket.
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
      type = str;
      default = "http://${localHost}:${toString cfg.port}";
      defaultText = lib.literalExpression ''"http://''${host}:''${toString port}"'';
      example = "https://example.com/prefect";
      description = ''
        External url the UI is reached at, when served by a reverse proxy.
        Defaults to the address the server itself binds, which is what you
        want when there is no proxy in front of it.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # define systemd.services as the server plus any worker definitions
    systemd.services = {
      "prefect-server" = {
        description = "prefect server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = hardening // {
          StateDirectory = "prefect-server";
          Environment = [
            "PREFECT_HOME=%S/prefect-server"
            "PREFECT_UI_STATIC_DIRECTORY=%S/prefect-server"
            "PREFECT_SERVER_ANALYTICS_ENABLED=off"
            "PREFECT_UI_API_URL=${cfg.baseUrl}/api"
            "PREFECT_UI_URL=${cfg.baseUrl}"
          ]
          ++ lib.optionals (cfg.database == "postgres") postgresEnvironment;

          EnvironmentFile = lib.optional (
            cfg.database == "postgres" && cfg.databasePasswordFile != null
          ) cfg.databasePasswordFile;

          ExecStart = "${lib.getExe cfg.package} server start --host ${cfg.host} --port ${toString cfg.port}";
          Restart = "always";
          WorkingDirectory = cfg.dataDir;
        };
      };
    }
    // lib.concatMapAttrs (poolName: poolCfg: {
      # return a partial attr set with one key: "prefect-worker-..."
      "prefect-worker-${poolName}" = {
        description = "prefect worker for pool '${poolName}'";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "prefect-server.service"
        ];

        # A process worker shells out to prefect for every flow run it picks
        # up, so the package has to be on its PATH and not merely in ExecStart.
        path = [ cfg.package ];

        serviceConfig = hardening // {
          StateDirectory = "prefect-worker-${poolName}";
          Environment = [
            "PREFECT_HOME=%S/prefect-worker-${poolName}"
            "PREFECT_API_URL=http://${localHost}:${toString cfg.port}/api"
          ];
          ExecStart = ''
            ${lib.getExe cfg.package} worker start \
              --pool ${poolName} \
              --type process \
              --install-policy ${poolCfg.installPolicy}
          '';
          Restart = "always";
        };
      };
    }) cfg.workerPools;
  };

  meta.maintainers = with lib.maintainers; [ happysalada ];
}
