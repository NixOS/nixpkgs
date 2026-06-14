{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.securo;
  inherit (lib)
    literalMD
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;

  pythonEnv = pkgs.python3.withPackages (_ps: [ cfg.package ]);

  backendEnv = {
    DATABASE_URL = cfg.database.url;
    DEBUG = lib.boolToString cfg.debug;
    FRONTEND_URL = cfg.frontend.url;
    REDIS_URL = cfg.redis.url;
    STORAGE_LOCAL_PATH = "${cfg.stateDir}/attachments";
  };

  withSecretKey =
    cmd:
    let
      f = lib.escapeShellArg cfg.secretKeyFile;
    in
    ''
      if [ -z "''${SECRET_KEY-}" ]; then
        if [ ! -s ${f} ]; then
          umask 0177
          ${pkgs.openssl.bin}/bin/openssl rand -base64 32 > ${f}
          chown ${cfg.user}:${cfg.group} ${f} 2>/dev/null || true
        fi
        SECRET_KEY="$(cat ${f})"
        export SECRET_KEY
        if [ -z "$SECRET_KEY" ]; then
          echo "SECRET_KEY is empty, refusing to start." >&2
          exit 1
        fi
      fi
      ${cmd}
    '';

  serviceDeps = [
    "network.target"
  ]
  ++ lib.optional cfg.database.enable "postgresql.service"
  ++ lib.optional cfg.redis.enable "redis-securo.service";

  mkBackendService =
    name: description: cmd:
    {
      serviceConfig ? { },
      unitConfig ? { },
    }:
    {
      "${name}" = {
        inherit description;
        after = serviceDeps ++ (unitConfig.after or [ ]);
        wants = serviceDeps;
        requires = unitConfig.requires or [ ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "${cfg.package}/share/securo";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          Restart = "on-failure";
          RestartSec = "5s";
          StateDirectory = "securo";
          StateDirectoryMode = "0750";
          UMask = "0027";
        }
        // serviceConfig;

        script = withSecretKey cmd;

        environment = backendEnv // cfg.extraEnv;
      };
    };
in
{
  options.services.securo = {
    enable = mkEnableOption "Securo self-hosted personal finance manager";

    package = mkPackageOption pkgs "securo" { };

    user = mkOption {
      type = types.str;
      default = "securo";
      description = "User under which Securo services run";
    };

    group = mkOption {
      type = types.str;
      default = "securo";
      description = "Group under which Securo services run";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/securo.env";
      description = ''
        Environment file loaded by all Securo systemd services.
        Used for secrets stored outside the Nix store (e.g. SECRET_KEY, API keys).
        Format: KEY=VALUE lines.
      '';
    };

    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/securo";
      description = "State directory for Securo data and runtime state.";
    };

    secretKeyFile = mkOption {
      type = types.str;
      default = "${cfg.stateDir}/secret_key";
      defaultText = literalMD ''"/var/lib/securo/secret_key"'';
      description = ''
        Path to a file containing the SECRET_KEY. If the file doesn't exist, it is
        auto-generated with a random value on first service start. If SECRET_KEY is
        already set via {option}`services.securo.environmentFile` or
        {option}`services.securo.extraEnv`, the file is not used.
      '';
    };

    extraEnv = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra environment variables passed to all Securo services";
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable debug mode for the Securo backend";
    };

    database = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to manage PostgreSQL locally via NixOS";
      };

      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database user and database automatically";
      };

      host = mkOption {
        type = types.str;
        default = "/run/postgresql";
        description = ''
          PostgreSQL host. Use "/run/postgresql" for Unix socket (peer auth).
        '';
      };

      port = mkOption {
        type = types.port;
        default = 5432;
        description = "PostgreSQL port";
      };

      name = mkOption {
        type = types.str;
        default = "securo";
        description = "PostgreSQL database name";
      };

      user = mkOption {
        type = types.str;
        default = "securo";
        description = "PostgreSQL user name";
      };

      password = mkOption {
        type = types.str;
        default = "";
        description = "PostgreSQL password. Leave empty with Unix socket (peer auth).";
      };

      url = mkOption {
        type = types.str;
        readOnly = true;
        defaultText = literalMD "Computed from `database.host`, `database.port`, `database.name`, `database.user`, and `database.password`.";
        description = "Read-only computed DATABASE_URL";
      };

      local = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable and configure local PostgreSQL service";
        };

        package = mkPackageOption pkgs "postgresql_16" { };

        extraPlugins = mkOption {
          type = types.listOf types.package;
          default = [ ];
          description = "Extra PostgreSQL plugins (e.g. pgvector). When using a locally-managed Postgres, add pgvector here (required by alembic migrations).";
        };
      };
    };

    redis = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to manage Redis locally via NixOS";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Redis host";
      };

      port = mkOption {
        type = types.port;
        default = 6379;
        description = "Redis port";
      };

      password = mkOption {
        type = types.str;
        default = "";
        description = "Redis password. Leave empty for no auth.";
      };

      database = mkOption {
        type = types.int;
        default = 0;
        description = "Redis database number";
      };

      url = mkOption {
        type = types.str;
        readOnly = true;
        defaultText = literalMD "Computed from `redis.host`, `redis.port`, `redis.password`, and `redis.database`.";
        description = "Read-only computed REDIS_URL";
      };
    };

    backend = {
      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Backend bind address";
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        description = "Backend bind port";
      };

      uvicornWorkers = mkOption {
        type = types.int;
        default = 1;
        description = "Number of uvicorn workers";
      };

      extraEnv = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Extra environment variables for the backend service";
      };
    };

    frontend = {
      url = mkOption {
        type = types.str;
        default = "http://localhost:3000";
        description = "FRONTEND_URL - the public-facing URL of the frontend";
      };

      backendUrl = mkOption {
        type = types.str;
        default = "http://127.0.0.1:8000";
        description = "BACKEND_URL - URL nginx proxies /api/ requests to";
      };

      nginx = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Configure an nginx virtual host for the frontend";
        };

        serverName = mkOption {
          type = types.str;
          default = "securo.local";
          description = "Server name for the nginx virtual host";
        };

        serverAliases = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Additional server names";
        };

        enableACME = mkOption {
          type = types.bool;
          default = false;
          description = "Enable ACME (Let's Encrypt) automatic certificate provisioning for the nginx virtual host. Cannot be used together with {option}`services.securo.frontend.nginx.useACMEHost`.";
        };

        useACMEHost = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Use TLS certificate from another ACME host. Cannot be used together with {option}`services.securo.frontend.nginx.enableACME`.";
        };

        forceSSL = mkOption {
          type = types.bool;
          default = false;
          description = "Force redirect to HTTPS";
        };
      };
    };

    celery = {
      concurrency = mkOption {
        type = types.int;
        default = 2;
        description = "Celery worker concurrency";
      };
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.frontend.nginx.enableACME && cfg.frontend.nginx.useACMEHost != null);
        message = "services.securo.frontend.nginx.enableACME and services.securo.frontend.nginx.useACMEHost are mutually exclusive and cannot be set simultaneously";
      }
    ];

    services.securo = {
      database.url = mkDefault (
        if lib.hasPrefix "/" cfg.database.host then
          "postgresql+asyncpg://${cfg.database.user}@/${cfg.database.name}?host=${cfg.database.host}"
        else if cfg.database.password == "" then
          "postgresql+asyncpg://${cfg.database.user}@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}"
        else
          "postgresql+asyncpg://${cfg.database.user}:${cfg.database.password}@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}"
      );
      redis.url = mkDefault (
        if cfg.redis.password == "" then
          "redis://${cfg.redis.host}:${toString cfg.redis.port}/${toString cfg.redis.database}"
        else
          "redis://:${cfg.redis.password}@${cfg.redis.host}:${toString cfg.redis.port}/${toString cfg.redis.database}"
      );
    };

    services.postgresql = mkIf (cfg.database.enable && cfg.database.local.enable) {
      enable = true;
      package = cfg.database.local.package;
      extensions =
        _:
        cfg.database.local.extraPlugins
        ++ lib.optional cfg.database.local.enable cfg.database.local.package.pkgs.pgvector;
      ensureDatabases = mkIf cfg.database.createLocally [ cfg.database.name ];
      ensureUsers = mkIf cfg.database.createLocally [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
          ensureClauses.login = true;
        }
      ];
      authentication = mkIf (cfg.database.host == "/run/postgresql") ''
        local all all peer
        host all all 127.0.0.1/32 scram-sha-256
        host all all ::1/128 scram-sha-256
      '';
    };

    services.redis = mkIf cfg.redis.enable {
      servers.securo = {
        enable = true;
        bind = cfg.redis.host;
        port = cfg.redis.port;
        requirePass = mkIf (cfg.redis.password != "") cfg.redis.password;
        settings.save = [ ];
      };
    };

    services.nginx = mkIf cfg.frontend.nginx.enable {
      enable = true;
      virtualHosts.${cfg.frontend.nginx.serverName} = {
        serverName = cfg.frontend.nginx.serverName;
        serverAliases = cfg.frontend.nginx.serverAliases;

        root = "${cfg.package}/share/securo-ui/dist";

        locations."/api/" = {
          proxyPass = cfg.frontend.backendUrl;
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };

        locations."= /index.html" = {
          extraConfig = "add_header Cache-Control 'no-store, no-cache, must-revalidate';";
        };

        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
        };

        inherit (cfg.frontend.nginx) enableACME useACMEHost forceSSL;
      };
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
      home = cfg.stateDir;
      createHome = true;
      description = "Securo service user";
    };

    users.groups.${cfg.group} = { };

    systemd.services = mkMerge [
      (mkBackendService "securo-migrate" "Securo database migration (alembic)"
        ''
          ${pkgs.sudo}/bin/sudo -u postgres ${cfg.database.local.package}/bin/psql -d postgres -c "CREATE USER ${cfg.database.user} WITH LOGIN" || true
          ${pkgs.sudo}/bin/sudo -u postgres ${cfg.database.local.package}/bin/psql -d postgres -c "CREATE DATABASE ${cfg.database.name} OWNER ${cfg.database.user}" || true
          ${pkgs.sudo}/bin/sudo -u postgres ${cfg.database.local.package}/bin/psql -d ${cfg.database.name} -c "CREATE EXTENSION IF NOT EXISTS vector"
          ${pkgs.sudo}/bin/sudo -u ${cfg.user} env DATABASE_URL="${cfg.database.url}" ${pythonEnv}/bin/alembic upgrade head
        ''
        {
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            Restart = "no";
            User = "root";
            Group = "root";
          };
        }
      )

      (mkBackendService "securo-server" "Securo backend (FastAPI/uvicorn)"
        "${pythonEnv}/bin/uvicorn app.main:app --host ${cfg.backend.host} --port ${toString cfg.backend.port} --workers ${toString cfg.backend.uvicornWorkers}"
        {
          unitConfig = {
            requires = [ "securo-migrate.service" ];
            after = [ "securo-migrate.service" ];
          };
        }
      )

      (mkBackendService "securo-celery-worker" "Securo Celery worker"
        "${pythonEnv}/bin/celery -A app.worker worker --loglevel=info --concurrency=${toString cfg.celery.concurrency}"
        { }
      )

      (mkBackendService "securo-celery-beat" "Securo Celery beat scheduler"
        "${pythonEnv}/bin/celery -A app.worker beat --loglevel=info --schedule=${cfg.stateDir}/celerybeat-schedule"
        {
          serviceConfig = {
            WorkingDirectory = cfg.stateDir;
          };
        }
      )
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.stateDir}/attachments 0750 ${cfg.user} ${cfg.group} -"
    ];
  };

  meta.maintainers = with lib.maintainers; [ pjrm ];
}
