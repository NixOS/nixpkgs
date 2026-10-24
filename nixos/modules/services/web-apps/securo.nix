{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.securo;
  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  pythonEnv = cfg.package.pythonModule.withPackages (_: [ cfg.package ]);
  secretKeyFile = "${cfg.dataDir}/secret_key";
  usePostgresqlSocket = lib.hasPrefix "/" cfg.database.host;

  databaseUrl =
    if usePostgresqlSocket then
      "postgresql+asyncpg://${cfg.database.user}@/${cfg.database.name}?host=${cfg.database.host}"
    else
      "postgresql+asyncpg://${cfg.database.user}@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";

  redisUrl = "redis://${cfg.redis.host}:${toString cfg.redis.port}/${toString cfg.redis.database}";

  commonEnv = {
    DEBUG = lib.boolToString cfg.debug;
    FRONTEND_URL = cfg.frontend.url;
    STORAGE_LOCAL_PATH = "${cfg.dataDir}/attachments";
  }
  # Environment variables take precedence over credential files in
  # pydantic-settings, so the plain URLs are only passed when no credential file
  # supersedes them.
  // lib.optionalAttrs (cfg.database.urlFile == null) { DATABASE_URL = databaseUrl; }
  // lib.optionalAttrs (cfg.redis.urlFile == null) { REDIS_URL = redisUrl; };

  # Securo reads its settings straight out of $CREDENTIALS_DIRECTORY via pydantic's
  # `secrets_dir`, looked up by field name, so systemd hands every secret over
  # directly and nothing has to be assembled in a shell wrapper. The names below
  # must match the field names in Securo's Settings class exactly.
  commonCredentials = [
    "secret_key:${secretKeyFile}"
  ]
  ++ lib.optional (cfg.database.urlFile != null) "database_url:${cfg.database.urlFile}"
  ++ lib.optional (cfg.redis.urlFile != null) "redis_url:${cfg.redis.urlFile}"
  ++ lib.mapAttrsToList (name: path: "${name}:${path}") cfg.credentials;

  serviceDeps =
    lib.optional cfg.database.createLocally "postgresql.target"
    ++ lib.optional cfg.redis.createLocally "redis-securo.service";

  # dataDir is configurable, so it cannot be managed with systemd's
  # StateDirectory (which is always relative to /var/lib). It is created by
  # tmpfiles instead and opened up explicitly under ProtectSystem = "strict".
  hardening = {
    ReadWritePaths = [ cfg.dataDir ];

    AmbientCapabilities = [ "" ];
    CapabilityBoundingSet = [ "" ];
    DevicePolicy = "closed";
    LockPersonality = true;
    # MemoryDenyWriteExecute and ProcSubset are deliberately not set: fastembed
    # pulls in onnxruntime, which needs W+X pages for its JIT, and the BLAS
    # backend sizes its thread pool from /proc/meminfo.
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProtectSystem = "strict";
    RemoveIPC = true;
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
    UMask = "0077";
  };

  mkBackendService =
    {
      description,
      command,
      environment ? { },
    }:
    {
      inherit description;

      after = [
        "network.target"
        "securo-secret-key.service"
        "securo-migrate.service"
      ]
      ++ serviceDeps;
      requires = [
        "securo-secret-key.service"
        "securo-migrate.service"
      ];
      wantedBy = [ "multi-user.target" ];

      environment = commonEnv // cfg.extraEnvironment // environment;

      serviceConfig = {
        Type = "simple";
        ExecStart = command;
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "${cfg.package}/share/securo";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        LoadCredential = commonCredentials;
        Restart = "on-failure";
        RestartSec = "5s";
      }
      // hardening;
    };
in
{
  options.services.securo = {
    enable = mkEnableOption "Securo, a self-hosted personal finance manager";

    package = mkPackageOption pkgs "securo" { };

    user = mkOption {
      type = types.str;
      default = "securo";
      description = "User under which Securo services run.";
    };

    group = mkOption {
      type = types.str;
      default = "securo";
      description = "Group under which Securo services run.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/securo";
      description = ''
        Directory used to store the generated secret key, uploaded attachments,
        and the Celery beat schedule.

        The directory is created automatically, but when it is not on the same
        filesystem as `/var/lib` the parent directories must already exist and be
        traversable by the Securo user.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/securo.env";
      description = ''
        Environment file loaded by all Securo systemd services, for secrets that
        should not end up in the Nix store. Format: `KEY=VALUE` lines.
      '';
    };

    extraEnvironment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra environment variables passed to all Securo services.";
    };

    credentials = mkOption {
      type = types.attrsOf types.path;
      default = { };
      example = literalExpression ''
        {
          plaid-secret = "/run/secrets/securo-plaid-secret";
        }
      '';
      description = ''
        Additional credentials passed to all Securo systemd services via
        {manpage}`systemd.exec(5)`'s `LoadCredential`. Each attribute name is the
        credential name, exposed as a file under `$CREDENTIALS_DIRECTORY`, and the
        value is the path to the credential file on disk.
      '';
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable debug mode for the Securo backend.";
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable a local PostgreSQL server and create the database and
          user automatically. Set to `false` to use an external database, in which
          case the database, user, and the `vector` extension must already exist.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "/run/postgresql";
        example = "db.example.com";
        description = ''
          PostgreSQL host. A path is interpreted as a Unix socket directory, which
          authenticates via peer auth and needs no password.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 5432;
        description = "PostgreSQL port.";
      };

      name = mkOption {
        type = types.str;
        default = "securo";
        description = "PostgreSQL database name.";
      };

      user = mkOption {
        type = types.str;
        default = "securo";
        description = "PostgreSQL user name.";
      };

      urlFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secrets/securo-database-url";
        description = ''
          Path to a file containing the full SQLAlchemy connection URL, for
          example `postgresql+asyncpg://securo:hunter2@db.example.com/securo`.

          Use this when the database requires a password: the file is passed to
          Securo through a systemd credential, so the password never enters the
          Nix store. It takes precedence over {option}`services.securo.database.host`
          and friends, which are then only used to derive service ordering.

          Not needed when connecting over a Unix socket, which uses peer
          authentication.
        '';
      };
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable and configure a local Redis server.";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Redis host.";
      };

      port = mkOption {
        type = types.port;
        default = 6379;
        description = "Redis port.";
      };

      urlFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secrets/securo-redis-url";
        description = ''
          Path to a file containing the full Redis connection URL, for example
          `redis://:hunter2@localhost:6379/0`.

          Use this when Redis requires a password: the file is passed to Securo
          through a systemd credential, so the password never enters the Nix store.
          It takes precedence over {option}`services.securo.redis.host` and friends.
        '';
      };

      database = mkOption {
        type = types.ints.unsigned;
        default = 0;
        description = "Redis database number.";
      };
    };

    backend = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address the backend binds to.";
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        description = "Port the backend binds to.";
      };

      uvicornWorkers = mkOption {
        type = types.ints.positive;
        default = 1;
        description = "Number of uvicorn worker processes.";
      };

      extraEnvironment = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Extra environment variables for the backend service.";
      };
    };

    frontend = {
      url = mkOption {
        type = types.str;
        default = "http://localhost";
        description = "Public-facing URL of the frontend, passed as `FRONTEND_URL`.";
      };

      backendUrl = mkOption {
        type = types.str;
        defaultText = literalExpression ''"http://''${config.services.securo.backend.host}:''${toString config.services.securo.backend.port}"'';
        description = "URL the reverse proxy forwards `/api/` requests to.";
      };

      nginx = {
        enable = mkEnableOption "a virtual host to serve the Securo frontend through nginx";

        domain = mkOption {
          type = types.str;
          default = "localhost";
          example = "securo.example.com";
          description = "Domain to use for the nginx virtual host.";
        };

        virtualHost = mkOption {
          type = types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
          default = { };
          example = literalExpression ''
            {
              enableACME = true;
              forceSSL = true;
            }
          '';
          description = "Extra configuration for the nginx virtual host of Securo.";
        };
      };
    };

    celery = {
      concurrency = mkOption {
        type = types.ints.positive;
        default = 2;
        description = "Number of concurrent Celery worker processes.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !usePostgresqlSocket -> !cfg.database.createLocally;
        message = ''
          services.securo.database.createLocally requires connecting over the
          PostgreSQL Unix socket. Either leave services.securo.database.host at
          its default, or set services.securo.database.createLocally = false.
        '';
      }
      {
        assertion = usePostgresqlSocket -> cfg.database.urlFile == null;
        message = ''
          services.securo.database.urlFile has no effect when connecting over the
          PostgreSQL Unix socket, which uses peer authentication. Set
          services.securo.database.host to a hostname to connect over TCP.
        '';
      }
      {
        assertion = cfg.redis.urlFile != null -> !cfg.redis.createLocally;
        message = ''
          services.securo.redis.urlFile has no effect on the Redis server managed
          by services.securo.redis.createLocally, which listens without a
          password. Set services.securo.redis.createLocally = false to point
          Securo at an external Redis.
        '';
      }
    ];

    services.securo.frontend.backendUrl = mkDefault "http://${cfg.backend.host}:${toString cfg.backend.port}";

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      extensions = ps: [ ps.pgvector ];
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
    };

    # pgvector ships the extension, but it still has to be created inside the
    # database before alembic can reference the vector type.
    systemd.services.postgresql-setup.postStart = mkIf cfg.database.createLocally ''
      psql -d ${cfg.database.name} -c 'CREATE EXTENSION IF NOT EXISTS vector'
    '';

    services.redis.servers.securo = mkIf cfg.redis.createLocally {
      enable = true;
      bind = cfg.redis.host;
      inherit (cfg.redis) port;
      settings.save = [ ];
    };

    services.nginx = mkIf cfg.frontend.nginx.enable {
      enable = mkDefault true;
      virtualHosts.${cfg.frontend.nginx.domain} = lib.mkMerge [
        (lib.mapAttrsRecursive (_: mkDefault) cfg.frontend.nginx.virtualHost)
        {
          root = lib.mkForce "${cfg.package.frontend}/share/securo-ui";

          locations = {
            "/api/" = {
              proxyPass = cfg.frontend.backendUrl;
              proxyWebsockets = true;
              recommendedProxySettings = true;
            };

            "= /index.html".extraConfig = ''
              add_header Cache-Control "no-store, no-cache, must-revalidate";
            '';

            "/".tryFiles = "$uri $uri/ /index.html";
          };
        }
      ];
    };

    users.users = mkIf (cfg.user == "securo") {
      securo = {
        inherit (cfg) group;
        isSystemUser = true;
        description = "Securo service user";
      };
    };

    users.groups = mkIf (cfg.group == "securo") { securo = { }; };

    systemd.services = {
      # A single one-shot unit owns key generation so the long-running services
      # cannot race each other into generating conflicting keys on first boot.
      securo-secret-key = {
        description = "Securo secret key generation";
        after = [
          "network.target"
          "systemd-tmpfiles-setup.service"
        ];
        requires = [ "systemd-tmpfiles-setup.service" ];
        wantedBy = [ "multi-user.target" ];

        unitConfig.ConditionPathExists = "!${secretKeyFile}";

        script = ''
          ${lib.getExe pkgs.openssl} rand -base64 32 > ${secretKeyFile}.tmp
          mv ${secretKeyFile}.tmp ${secretKeyFile}
        '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = cfg.user;
          Group = cfg.group;
        }
        // hardening;
      };

      securo-migrate = {
        description = "Securo database migration (alembic)";

        after = [
          "network.target"
          "securo-secret-key.service"
        ]
        ++ serviceDeps;
        requires = [ "securo-secret-key.service" ];
        wantedBy = [ "multi-user.target" ];

        environment = commonEnv // cfg.extraEnvironment;

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pythonEnv}/bin/alembic upgrade head";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "${cfg.package}/share/securo";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          LoadCredential = commonCredentials;
        }
        // hardening;
      };

      securo-server = mkBackendService {
        description = "Securo backend (FastAPI/uvicorn)";
        command = "${pythonEnv}/bin/uvicorn app.main:app --host ${cfg.backend.host} --port ${toString cfg.backend.port} --workers ${toString cfg.backend.uvicornWorkers}";
        environment = cfg.backend.extraEnvironment;
      };

      securo-celery-worker = mkBackendService {
        description = "Securo Celery worker";
        command = "${pythonEnv}/bin/celery -A app.worker worker --loglevel=info --concurrency=${toString cfg.celery.concurrency}";
      };

      securo-celery-beat = mkBackendService {
        description = "Securo Celery beat scheduler";
        command = "${pythonEnv}/bin/celery -A app.worker beat --loglevel=info --schedule=${cfg.dataDir}/celerybeat-schedule";
      };
    };

    systemd.tmpfiles.settings."10-securo" = {
      ${cfg.dataDir}.d = {
        inherit (cfg) user group;
        mode = "0750";
      };
      "${cfg.dataDir}/attachments".d = {
        inherit (cfg) user group;
        mode = "0750";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ pjrm ];
}
