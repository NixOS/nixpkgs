{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.immich;
  isPostgresUnixSocket = lib.hasPrefix "/" cfg.database.host;
  isRedisUnixSocket = lib.hasPrefix "/" cfg.redis.host;

  commonServiceConfig = {
    Type = "simple";
    Restart = "on-failure";
    RestartSec = 3;

    # Hardening
    CapabilityBoundingSet = "";
    NoNewPrivileges = true;
    PrivateUsers = true;
    PrivateTmp = true;
    PrivateDevices = true;
    PrivateMounts = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
  };
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in
{
  options.services.immich = {
    enable = mkEnableOption "Immich";
    package = lib.mkPackageOption pkgs "immich" { };

    mediaLocation = mkOption {
      type = types.path;
      default = "/var/lib/immich";
      description = "Directory used to store media files. If it is not the default, the directory has to be created manually such that the immich user is able to read and write to it.";
    };
    environment = mkOption {
      type = types.submodule { freeformType = types.attrsOf types.str; };
      default = { };
      example = {
        IMMICH_LOG_LEVEL = "verbose";
      };
      description = ''
        Extra configuration environment variables. Refer to the [documentation](https://immich.app/docs/install/environment-variables) for options tagged with 'server', 'api' or 'microservices'.
      '';
    };
    secretsFile = mkOption {
      type = types.nullOr (
        types.str
        // {
          # We don't want users to be able to pass a path literal here but
          # it should look like a path.
          check = it: lib.isString it && lib.types.path.check it;
        }
      );
      default = null;
      example = "/run/secrets/immich";
      description = ''
        Path of a file with extra environment variables to be loaded from disk. This file is not added to the nix store, so it can be used to pass secrets to immich. Refer to the [documentation](https://immich.app/docs/install/environment-variables) for options.

        To set a database password set this to a file containing:
        ```
        DB_PASSWORD=<pass>
        ```
      '';
    };
    host = mkOption {
      type = types.str;
      default = "localhost";
      description = "The host that immich will listen on.";
    };
    port = mkOption {
      type = types.port;
      default = 3001;
      description = "The port that immich will listen on.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the immich port in the firewall";
    };
    user = mkOption {
      type = types.str;
      default = "immich";
      description = "The user immich should run as.";
    };
    group = mkOption {
      type = types.str;
      default = "immich";
      description = "The group immich should run as.";
    };

    machine-learning = {
      enable =
        mkEnableOption "immich's machine-learning functionality to detect faces and search for objects"
        // {
          default = true;
        };
      environment = mkOption {
        type = types.submodule { freeformType = types.attrsOf types.str; };
        default = { };
        example = {
          MACHINE_LEARNING_MODEL_TTL = "600";
        };
        description = ''
          Extra configuration environment variables. Refer to the [documentation](https://immich.app/docs/install/environment-variables) for options tagged with 'machine-learning'.
        '';
      };
    };

    database = {
      enable =
        mkEnableOption "the postgresql database for use with immich. See {option}`services.postgresql`"
        // {
          default = true;
        };
      createDB = mkEnableOption "the automatic creation of the database for immich." // {
        default = true;
      };
      name = mkOption {
        type = types.str;
        default = "immich";
        description = "The name of the immich database.";
      };
      host = mkOption {
        type = types.str;
        default = "/run/postgresql";
        example = "127.0.0.1";
        description = "Hostname or address of the postgresql server. If an absolute path is given here, it will be interpreted as a unix socket path.";
      };
      user = mkOption {
        type = types.str;
        default = "immich";
        description = "The database user for immich.";
      };
    };
    redis = {
      enable = mkEnableOption "a redis cache for use with immich" // {
        default = true;
      };
      host = mkOption {
        type = types.str;
        default = config.services.redis.servers.immich.unixSocket;
        defaultText = lib.literalExpression "config.services.redis.servers.immich.unixSocket";
        description = "The host that redis will listen on.";
      };
      port = mkOption {
        type = types.port;
        default = 0;
        description = "The port that redis will listen on. Set to zero to disable TCP.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !isPostgresUnixSocket -> cfg.secretsFile != null;
        message = "A secrets file containing at least the database password must be provided when unix sockets are not used.";
      }
    ];

    services.postgresql = mkIf cfg.database.enable {
      enable = true;
      ensureDatabases = mkIf cfg.database.createDB [ cfg.database.name ];
      ensureUsers = mkIf cfg.database.createDB [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
      extraPlugins = ps: with ps; [ pgvecto-rs ];
      settings = {
        shared_preload_libraries = [ "vectors.so" ];
        search_path = "\"$user\", public, vectors";
      };
    };
    systemd.services.postgresql.serviceConfig.ExecStartPost =
      let
        sqlFile = pkgs.writeText "immich-pgvectors-setup.sql" ''
          CREATE EXTENSION IF NOT EXISTS unaccent;
          CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
          CREATE EXTENSION IF NOT EXISTS vectors;
          CREATE EXTENSION IF NOT EXISTS cube;
          CREATE EXTENSION IF NOT EXISTS earthdistance;
          CREATE EXTENSION IF NOT EXISTS pg_trgm;

          ALTER SCHEMA public OWNER TO ${cfg.database.user};
          ALTER SCHEMA vectors OWNER TO ${cfg.database.user};
          GRANT SELECT ON TABLE pg_vector_index_stat TO ${cfg.database.user};

          ALTER EXTENSION vectors UPDATE;
        '';
      in
      [
        ''
          ${lib.getExe' config.services.postgresql.package "psql"} -d "${cfg.database.name}" -f "${sqlFile}"
        ''
      ];

    services.redis.servers = mkIf cfg.redis.enable {
      immich = {
        enable = true;
        user = cfg.user;
        port = cfg.redis.port;
        bind = mkIf (!isRedisUnixSocket) cfg.redis.host;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    services.immich.environment =
      let
        postgresEnv =
          if isPostgresUnixSocket then
            { DB_URL = "socket://${cfg.database.host}?dbname=${cfg.database.name}"; }
          else
            {
              DB_HOSTNAME = cfg.database.host;
              DB_PORT = toString cfg.database.port;
              DB_DATABASE_NAME = cfg.database.name;
              DB_USERNAME = cfg.database.user;
            };
        redisEnv =
          if isRedisUnixSocket then
            { REDIS_SOCKET = cfg.redis.host; }
          else
            {
              REDIS_PORT = toString cfg.redis.port;
              REDIS_HOSTNAME = cfg.redis.host;
            };
      in
      postgresEnv
      // redisEnv
      // {
        HOST = cfg.host;
        IMMICH_PORT = toString cfg.port;
        IMMICH_MEDIA_LOCATION = cfg.mediaLocation;
        IMMICH_MACHINE_LEARNING_URL = "http://localhost:3003";
      };

    services.immich.machine-learning.environment = {
      MACHINE_LEARNING_WORKERS = "1";
      MACHINE_LEARNING_WORKER_TIMEOUT = "120";
      MACHINE_LEARNING_CACHE_FOLDER = "/var/cache/immich";
      IMMICH_HOST = "localhost";
      IMMICH_PORT = "3003";
    };

    systemd.services.immich-server = {
      description = "Immich backend server (Self-hosted photo and video backup solution)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      inherit (cfg) environment;

      serviceConfig = commonServiceConfig // {
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = mkIf (cfg.secretsFile != null) cfg.secretsFile;
        StateDirectory = "immich";
        RuntimeDirectory = "immich";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    systemd.services.immich-machine-learning = mkIf cfg.machine-learning.enable {
      description = "immich machine learning";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      inherit (cfg.machine-learning) environment;
      serviceConfig = commonServiceConfig // {
        ExecStart = lib.getExe (cfg.package.machine-learning.override { immich = cfg.package; });
        CacheDirectory = "immich";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    users.users = mkIf (cfg.user == "immich") {
      immich = {
        name = "immich";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = mkIf (cfg.group == "immich") { immich = { }; };

    meta.maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
