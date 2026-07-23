# Copyright (c) 2025 NixOS contributors
# SPDX-License-Identifier: MIT
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.plane;
  pkg = cfg.package;

  # Env file syntax: KEY=value, one per line, passed to systemd EnvironmentFile
  commonEnv = {
    DJANGO_SETTINGS_MODULE = "plane.settings.production";
    PYTHONPATH = "${pkg}/lib/plane";
    PLANE_LOG_DIR = cfg.logDir;
  };

  envToString = env: lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}=${v}") env);
in
{
  options.services.plane = {
    enable = lib.mkEnableOption "Plane project management server";

    package = lib.mkPackageOption pkgs "plane" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "plane";
      description = "User account under which Plane runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "plane";
      description = "Group under which Plane runs.";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/plane";
      description = "Directory for Plane state (uploaded files, staticfiles).";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/log/plane";
      description = "Directory for Plane log files.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/plane.env";
      description = ''
        Path to a file containing secret environment variables for Plane.
        This file is read by systemd and must not be world-readable.

        Required variables:
        - SECRET_KEY: Django secret key (generate with: python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())")
        - DATABASE_URL: PostgreSQL connection string, e.g. postgres://plane:password@localhost/plane
        - REDIS_URL: Redis/Valkey URL, e.g. redis://localhost:6379/0

        Optional variables:
        - AMQP_URL: RabbitMQ URL (defaults to using Redis as broker)
        - AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_S3_BUCKET_NAME, AWS_S3_ENDPOINT_URL: S3/MinIO storage
        - OPENAI_API_KEY: for AI features
        - SCOUT_KEY, SCOUT_MONITOR: Scout APM
        - GUNICORN_WORKERS: number of API workers (default: 2)
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Port the Plane API server listens on.";
    };

    livePort = lib.mkOption {
      type = lib.types.port;
      default = 3100;
      description = "Port the Plane live collaboration server listens on.";
    };

    gunicornWorkers = lib.mkOption {
      type = lib.types.ints.positive;
      default = 2;
      description = "Number of gunicorn worker processes for the API server.";
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to create a local PostgreSQL database.
          If enabled, DATABASE_URL is set automatically and does not need to
          be in the environmentFile.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "plane";
        description = "Local PostgreSQL database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "plane";
        description = "Local PostgreSQL user.";
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to create a local Valkey (Redis-compatible) instance.";
      };
    };

    nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to configure nginx as a reverse proxy for Plane.
          Requires services.nginx.enable = true.
        '';
      };

      serverName = lib.mkOption {
        type = lib.types.str;
        example = "plane.example.com";
        description = "The nginx server_name for the Plane virtual host.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.environmentFile != null || cfg.database.createLocally;
        message = "services.plane: set environmentFile (with DATABASE_URL and SECRET_KEY) or enable database.createLocally";
      }
      {
        assertion = cfg.nginx.enable -> cfg.nginx.serverName != "";
        message = "services.plane.nginx.enable requires services.plane.nginx.serverName to be set";
      }
    ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.stateDir;
      description = "Plane service user";
    };
    users.groups.${cfg.group} = { };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.package = lib.mkIf cfg.redis.createLocally pkgs.valkey;
    services.redis.servers.plane = lib.mkIf cfg.redis.createLocally {
      enable = true;
      port = 6379;
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}'          0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/static'   0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.stateDir}/media'    0750 ${cfg.user} ${cfg.group} - -"
      "d '${cfg.logDir}'            0750 ${cfg.user} ${cfg.group} - -"
    ];

    # Write shared env vars (non-secret) to a file read by all services
    environment.etc."plane/env".text = envToString (
      commonEnv
      // {
        PORT = toString cfg.port;
        GUNICORN_WORKERS = toString cfg.gunicornWorkers;
        STATIC_ROOT = "${cfg.stateDir}/static";
        MEDIA_ROOT = "${cfg.stateDir}/media";
      }
      // lib.optionalAttrs cfg.database.createLocally {
        DATABASE_URL = "postgres:///${cfg.database.name}?host=/run/postgresql";
      }
      // lib.optionalAttrs cfg.redis.createLocally {
        REDIS_URL = "redis://localhost:${toString config.services.redis.servers.plane.port}/0";
        CELERY_BROKER_URL = "redis://localhost:${toString config.services.redis.servers.plane.port}/1";
      }
    );

    systemd.services.plane-migrate = {
      description = "Plane database migrations";
      after = [
        "network.target"
        "postgresql.service"
      ];
      requires = lib.optional cfg.database.createLocally "postgresql.service";
      wantedBy = [ "plane-api.service" ];
      before = [
        "plane-api.service"
        "plane-worker.service"
        "plane-beat.service"
      ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkMerge [
          [ "/etc/plane/env" ]
          (lib.optional (cfg.environmentFile != null) cfg.environmentFile)
        ];
        ExecStart = "${pkg}/bin/plane-manage migrate --noinput";
        RemainAfterExit = true;
      };
    };

    systemd.services.plane-collectstatic = {
      description = "Plane collect static files";
      after = [ "plane-migrate.service" ];
      wantedBy = [ "plane-api.service" ];
      before = [ "plane-api.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkMerge [
          [ "/etc/plane/env" ]
          (lib.optional (cfg.environmentFile != null) cfg.environmentFile)
        ];
        ExecStart = "${pkg}/bin/plane-manage collectstatic --noinput";
        RemainAfterExit = true;
      };
    };

    systemd.services.plane-api = {
      description = "Plane API server";
      after = [
        "network.target"
        "plane-migrate.service"
        "plane-collectstatic.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkMerge [
          [ "/etc/plane/env" ]
          (lib.optional (cfg.environmentFile != null) cfg.environmentFile)
        ];
        ExecStart = lib.escapeShellArgs [
          "${pkg}/bin/plane-api"
          "--bind"
          "0.0.0.0:${toString cfg.port}"
          "--workers"
          "${toString cfg.gunicornWorkers}"
        ];
        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ReadWritePaths = [
          cfg.stateDir
          cfg.logDir
        ];
        NoNewPrivileges = true;
      };
    };

    systemd.services.plane-worker = {
      description = "Plane Celery worker";
      after = [
        "network.target"
        "plane-migrate.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkMerge [
          [ "/etc/plane/env" ]
          (lib.optional (cfg.environmentFile != null) cfg.environmentFile)
        ];
        ExecStart = "${pkg}/bin/plane-worker";
        Restart = "on-failure";
        RestartSec = "5s";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ReadWritePaths = [
          cfg.stateDir
          cfg.logDir
        ];
        NoNewPrivileges = true;
      };
    };

    systemd.services.plane-beat = {
      description = "Plane Celery beat scheduler";
      after = [
        "network.target"
        "plane-migrate.service"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkMerge [
          [ "/etc/plane/env" ]
          (lib.optional (cfg.environmentFile != null) cfg.environmentFile)
        ];
        ExecStart = "${pkg}/bin/plane-beat";
        Restart = "on-failure";
        RestartSec = "5s";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        ReadWritePaths = [
          cfg.stateDir
          cfg.logDir
        ];
        NoNewPrivileges = true;
      };
    };

    systemd.services.plane-live = {
      description = "Plane live collaboration server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        PORT = toString cfg.livePort;
        NODE_ENV = "production";
      };
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = "${pkg.passthru.frontend}/share/plane/live";
        ExecStart = "${pkgs.nodejs_22}/bin/node .";
        Restart = "on-failure";
        RestartSec = "5s";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    services.nginx.virtualHosts = lib.mkIf cfg.nginx.enable {
      ${cfg.nginx.serverName} = {
        locations = {
          # API
          "~ ^/(api|auth|s3|spaces/api|god-mode)" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          # Live collaboration (WebSocket)
          "/live" = {
            proxyPass = "http://127.0.0.1:${toString cfg.livePort}";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_set_header Host $host;
            '';
          };

          # Admin SPA
          "/god-mode" = {
            root = "${pkg.passthru.frontend}/share/plane/admin";
            tryFiles = "$uri $uri/ /index.html";
            extraConfig = "add_header Cache-Control 'no-cache';";
          };

          # Space SSR (proxy to react-router-serve)
          "/spaces" = {
            proxyPass = "http://127.0.0.1:3002";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          # Static files (collected by manage.py collectstatic)
          "/static" = {
            alias = "${cfg.stateDir}/static";
            extraConfig = "expires 30d;";
          };

          # Media uploads
          "/media" = {
            alias = "${cfg.stateDir}/media";
          };

          # Main web SPA — catch-all
          "/" = {
            root = "${pkg.passthru.frontend}/share/plane/web";
            tryFiles = "$uri $uri/ /index.html";
          };
        };
      };
    };

    # Space SSR service (only needed when nginx is enabled and routes /spaces to it)
    systemd.services.plane-space = lib.mkIf cfg.nginx.enable {
      description = "Plane space SSR server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        PORT = "3002";
        NODE_ENV = "production";
      };
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        WorkingDirectory = "${pkg.passthru.frontend}/share/plane/space";
        ExecStart = "${pkg.passthru.frontend}/share/plane/space/node_modules/.bin/react-router-serve ./build/server/index.js";
        Restart = "on-failure";
        RestartSec = "5s";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };
  };
}
