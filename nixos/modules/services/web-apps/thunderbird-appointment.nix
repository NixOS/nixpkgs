{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    filterAttrs
    getExe'
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalAttrs
    removePrefix
    types
    ;
  inherit (lib.generators) mkValueStringDefault toKeyValue;

  cfg = config.services.thunderbird-appointment;

  baseUrl = "https://${cfg.nginx.domain}";
  redisEnabled = cfg.redis.createLocally;
  pgEnabled = cfg.database.createLocally;

  toEnvValue =
    v:
    if lib.isBool v then
      (if v then "True" else "False")
    else if lib.isList v then
      concatStringsSep "," (map toString v)
    else
      mkValueStringDefault { } v;

  settingsEnv = mapAttrs (_: toEnvValue) (filterAttrs (_: v: v != null) cfg.settings);

  managedEnv =
    optionalAttrs pgEnabled {
      DATABASE_ENGINE = "postgresql";
      # Unix-socket peer auth as the service user (no password in the store).
      DATABASE_URL = "postgresql+psycopg:///${cfg.user}?host=/run/postgresql";
    }
    // optionalAttrs redisEnabled {
      REDIS_URL = "127.0.0.1";
      REDIS_PORT = toString cfg.redis.port;
      REDIS_DB = "0";
      REDIS_CELERY_DB = "2";
      REDIS_CELERY_RESULTS_DB = "3";
    }
    // optionalAttrs (cfg.nginx.domain != null) {
      FRONTEND_URL = baseUrl;
      # OAuth callbacks resolve back through the same proxied /api/v1 prefix.
      BACKEND_URL = "${baseUrl}/api/v1";
      SHORT_BASE_URL = if cfg.shortBaseUrl != null then cfg.shortBaseUrl else baseUrl;
    };

  serviceEnv = managedEnv // settingsEnv;

  # The SPA bakes its backend URL at build time (Vite `import.meta.env.VITE_*`)
  # So we must rebuild the frontend per deployment with the real domain.
  frontendEnv = {
    VITE_API_URL = "${cfg.nginx.domain}/api/v1";
    VITE_BASE_URL = cfg.nginx.domain;
    VITE_API_SECURE = "true";
    VITE_API_PORT = "";
    VITE_SHORT_BASE_URL =
      if cfg.shortBaseUrl != null then removePrefix "https://" cfg.shortBaseUrl else cfg.nginx.domain;
    VITE_AUTH_SCHEME = cfg.settings.AUTH_SCHEME;
  }
  // cfg.frontend.extraEnv;

  frontend = cfg.package.frontend.overrideAttrs (old: {
    preBuild = ''
      printf '%s' "${toKeyValue { } frontendEnv}" > .env.production
    ''
    + (old.preBuild or "");
  });

  secretsEnvFile = "${cfg.dataDir}/secrets.env";

  hardening = {
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectHostname = true;
    ProtectClock = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    RestrictRealtime = true;
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;
    LockPersonality = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
    ];
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      "~@resources"
    ];
    CapabilityBoundingSet = "";
    UMask = "0077";
  };

  commonServiceConfig = hardening // {
    User = cfg.user;
    Group = cfg.group;
    StateDirectory = "thunderbird-appointment";
    WorkingDirectory = cfg.dataDir;
    EnvironmentFile = [ secretsEnvFile ] ++ optional (cfg.environmentFile != null) cfg.environmentFile;
    Restart = "on-failure";
    RestartSec = "5s";
  };
in
{
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  options.services.thunderbird-appointment = {
    enable = mkEnableOption "Thunderbird Appointment, a calendar scheduling service";

    package = mkPackageOption pkgs "thunderbird-appointment" { };

    user = mkOption {
      type = types.str;
      default = "thunderbird-appointment";
      description = "User under which Thunderbird Appointment runs.";
    };

    group = mkOption {
      type = types.str;
      default = "thunderbird-appointment";
      description = "Group under which Thunderbird Appointment runs.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/thunderbird-appointment";
      description = "State directory for the service (holds generated secrets).";
    };

    shortBaseUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "https://apt.example.com";
      description = ''
        Base URL used for short booking links (`SHORT_BASE_URL`). Defaults to the
        main `https://<domain>` when unset.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/thunderbird-appointment.env";
      description = ''
        Environment file loaded last (overrides everything). Use it for external
        secrets such as `SMTP_PASS`, `FXA_SECRET`, `OIDC_CLIENT_SECRET`,
        `GOOGLE_AUTH_SECRET`, or to override the auto-generated app secrets.
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        Configuration exposed as environment variables. Attribute names are the
        upstream variable names verbatim (see `backend/.env.example`). Booleans
        become `True`/`False`, lists become comma-separated. Secrets belong in
        {option}`environmentFile`, not here.
      '';
      type = types.submodule {
        freeformType = types.attrsOf (
          types.oneOf [
            types.bool
            types.int
            types.str
            (types.listOf types.str)
          ]
        );
        options = {
          APP_ENV = mkOption {
            type = types.str;
            default = "production";
            description = "Application environment.";
          };
          LOG_LEVEL = mkOption {
            type = types.str;
            default = "INFO";
            description = "Backend log level.";
          };
          AUTH_SCHEME = mkOption {
            type = types.enum [
              "password"
              "fxa"
              "oidc"
              "accounts"
            ];
            default = "password";
            description = "Authentication scheme. Must match the frontend build.";
          };
          APP_ALLOW_FIRST_TIME_REGISTER = mkOption {
            type = types.bool;
            default = true;
            description = "Allow first-time self-registration (needed for initial admin setup).";
          };
          APP_ADMIN_ALLOW_LIST = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = [ "@example.com" ];
            description = "Email suffixes permitted to reach admin endpoints.";
          };
        };
      };
    };

    frontend.extraEnv = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        VITE_OIDC_CLIENT_ID = "thunderbird-appointment-frontend";
        VITE_OIDC_ROOT_URL = "https://auth.example.com/realms/example/";
        VITE_SENTRY_DSN = "";
      };
      description = ''
        Extra build-time `VITE_*` variables baked into the SPA (OIDC/FXA client
        IDs, PostHog keys, Sentry DSN, ...). Required when `AUTH_SCHEME` is not
        `password`.
      '';
    };

    database.createLocally = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Provision a local PostgreSQL database with socket peer-auth. When false,
        provide `DATABASE_ENGINE`/`DATABASE_URL` (or the `DATABASE_*` components)
        via {option}`settings`/{option}`environmentFile`.
      '';
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Provision a local Redis instance for the Celery broker/backend.";
      };
      port = mkOption {
        type = types.port;
        default = 6379;
        description = "TCP port for the local Redis instance (bound to 127.0.0.1).";
      };
    };

    flower.enable = mkEnableOption "the Flower Celery monitoring UI (on 127.0.0.1:5555)";

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Serve the SPA and proxy the API through nginx with ACME TLS.";
      };
      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "appointment.example.com";
        description = "Public domain. Required, as the SPA bakes it in at build time.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.nginx.domain != null;
        message = "services.thunderbird-appointment.nginx.domain must be set (the frontend bakes it in at build time).";
      }
    ];

    users.users = mkIf (cfg.user == "thunderbird-appointment") {
      thunderbird-appointment = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
      };
    };

    users.groups = mkIf (cfg.group == "thunderbird-appointment") {
      thunderbird-appointment = { };
    };

    services.postgresql = mkIf pgEnabled {
      enable = true;
      ensureDatabases = [ cfg.user ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.thunderbird-appointment = mkIf redisEnabled {
      enable = true;
      bind = "127.0.0.1";
      port = cfg.redis.port;
    };

    systemd.services = {
      thunderbird-appointment-secrets = {
        description = "Generate Thunderbird Appointment secrets";
        wantedBy = [ "multi-user.target" ];
        before = [
          "thunderbird-appointment.service"
          "thunderbird-appointment-worker.service"
        ];
        path = [ pkgs.openssl ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = "thunderbird-appointment";
          WorkingDirectory = cfg.dataDir;
          UMask = "0077";
        };
        script = ''
          if [ ! -e ${secretsEnvFile} ]; then
            {
              echo "SESSION_SECRET=$(openssl rand -hex 32)"
              echo "JWT_SECRET=$(openssl rand -hex 32)"
              echo "CSRF_SECRET=$(openssl rand -hex 32)"
              echo "SIGNED_SECRET=$(openssl rand -hex 32)"
              echo "DB_SECRET=$(openssl rand -hex 32)"
            } > ${secretsEnvFile}
          fi
        '';
      };

      thunderbird-appointment = {
        description = "Thunderbird Appointment API (FastAPI/uvicorn)";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "thunderbird-appointment-secrets.service"
        ]
        ++ optional pgEnabled "postgresql.service"
        ++ optional redisEnabled "redis-thunderbird-appointment.service";
        requires = [
          "thunderbird-appointment-secrets.service"
        ]
        ++ optional pgEnabled "postgresql.service"
        ++ optional redisEnabled "redis-thunderbird-appointment.service";
        environment = serviceEnv;
        serviceConfig = commonServiceConfig // {
          ExecStartPre = "${getExe' cfg.package "run-command"} main update-db";
          ExecStart = getExe' cfg.package "thunderbird-appointment-api";
        };
      };

      thunderbird-appointment-worker = {
        description = "Thunderbird Appointment Celery worker (embedded beat)";
        wantedBy = [ "multi-user.target" ];
        after = [
          "thunderbird-appointment.service"
          "thunderbird-appointment-secrets.service"
        ]
        ++ optional redisEnabled "redis-thunderbird-appointment.service";
        requires = [
          "thunderbird-appointment-secrets.service"
        ]
        ++ optional redisEnabled "redis-thunderbird-appointment.service";
        environment = serviceEnv;
        serviceConfig = commonServiceConfig // {
          ExecStart = getExe' cfg.package "thunderbird-appointment-worker";
        };
      };

      thunderbird-appointment-flower = mkIf cfg.flower.enable {
        description = "Thunderbird Appointment Celery Flower monitor";
        wantedBy = [ "multi-user.target" ];
        after = [
          "thunderbird-appointment-secrets.service"
        ]
        ++ optional redisEnabled "redis-thunderbird-appointment.service";
        environment = serviceEnv;
        serviceConfig = commonServiceConfig // {
          ExecStart = getExe' cfg.package "thunderbird-appointment-flower";
        };
      };
    };

    services.nginx = mkIf cfg.nginx.enable {
      enable = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;
      virtualHosts.${cfg.nginx.domain} = {
        forceSSL = true;
        enableACME = true;
        root = "${frontend}/dist";
        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
        };
        locations."/api/v1/" = {
          proxyPass = "http://127.0.0.1:5000/";
          proxyWebsockets = true;
          extraConfig = "client_max_body_size 10M;";
        };
      };
    };
  };
}
