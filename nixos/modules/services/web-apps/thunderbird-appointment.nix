{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalString
    types
    ;

  cfg = config.services.thunderbird-appointment;

  package = cfg.package;

  # Map common settings to env vars
  envVars = lib.mapAttrs' (name: value: {
    name = if name == "secretKey" then "APP_SECRET_KEY" else "APP_${lib.toUpper name}";
    value = if lib.isBool value then lib.boolToString value else toString value;
  }) cfg.settings;

  commonServiceConfig = {
    User = cfg.user;
    Group = cfg.group;
    StateDirectory = "thunderbird-appointment";
    RuntimeDirectory = "thunderbird-appointment";
    WorkingDirectory = cfg.dataDir;
    EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

    ProtectSystem = "strict";
    PrivateTmp = true;
    NoNewPrivileges = true;
    RestrictRealtime = true;
    PrivateDevices = true;
    ProtectHome = true;
    ProtectKernelTunables = true;
  };
in
{
  meta.maintainers = with lib.maintainers; [ philocalyst ];

  options.services.thunderbird-appointment = {
    enable = mkEnableOption "Thunderbird Appointment (calendar appointment booking)";

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
      description = "Directory for data and state.";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/thunderbird-appointment.env";
      description = "Environment file for secrets (APP_SECRET_KEY, DB passwords, Google/Zoom keys, etc.).";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf types.anything;
        options = {
          allowFirstTimeRegister = mkOption {
            type = types.bool;
            default = true;
            description = "Allow first time user registration (required for initial setup).";
          };
          adminAllowList = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of emails allowed to access admin features.";
          };
          secretKey = mkOption {
            type = types.str;
            default = "change-me-in-production-using-environmentFile";
            description = "Secret key for sessions. Use environmentFile for production.";
          };
          dbUrl = mkOption {
            type = types.str;
            default = "postgresql+psycopg://thunderbird-appointment:@localhost/thunderbird_appointment";
            description = "Database URL (use environmentFile for password).";
          };
        };
      };
      default = { };
      description = "Configuration settings converted to APP_* environment variables. See backend/.env.example for full list.";
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable Nginx virtual host for frontend and API proxy.";
      };

      domain = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "appointment.example.com";
        description = "Domain to serve Thunderbird Appointment on.";
      };
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to create a local PostgreSQL database and user automatically.";
      };
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to create a local Redis instance for Celery broker.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.nginx.enable -> (cfg.nginx.domain != null);
        message = "services.thunderbird-appointment.nginx.domain must be set when nginx is enabled.";
      }
    ];

    users.users = mkIf (cfg.user == "thunderbird-appointment") {
      thunderbird-appointment = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = mkIf (cfg.group == "thunderbird-appointment") {
      thunderbird-appointment = { };
    };

    services.postgresql = mkIf (cfg.database.createLocally) {
      enable = true;
      ensureDatabases = [ "thunderbird_appointment" ];
      ensureUsers = [
        {
          name = "thunderbird-appointment";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.thunderbird-appointment = mkIf cfg.redis.createLocally {
      enable = true;
    };

    systemd.services = {
      thunderbird-appointment = {
        description = "Thunderbird Appointment backend (FastAPI)";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "postgresql.service"
          "redis-thunderbird-appointment.service"
        ];
        requires = lib.optional cfg.database.createLocally "postgresql.service";

        environment = envVars // {
          APP_ENV = "production";
          FRONTEND_DIR = "${package}/share/thunderbird-appointment/frontend";
        };

        serviceConfig = commonServiceConfig // {
          ExecStart = "${getExe' package "uvicorn"} appointment.main:app --host 127.0.0.1 --port 5000";
          Restart = "on-failure";
        };

        preStart = ''
          # Run migrations and setup (matches upstream docker entrypoint and backend/README.md)
          ${getExe' package "run-command"} main update-db || true
          ${optionalString cfg.settings.allowFirstTimeRegister ''
            echo "First time registration enabled via APP_ALLOW_FIRST_TIME_REGISTER. Create initial admin user via web UI."
          ''}
        '';
      };

      thunderbird-appointment-celery = {
        description = "Thunderbird Appointment Celery worker";
        after = [ "thunderbird-appointment.service" ];
        wants = [ "thunderbird-appointment.service" ];
        serviceConfig = commonServiceConfig // {
          ExecStart = "${getExe' package "celery"} -A appointment.celery_app worker --loglevel=info";
          Restart = "on-failure";
        };
      };

      thunderbird-appointment-beat = {
        description = "Thunderbird Appointment Celery beat scheduler (redbeat)";
        after = [ "thunderbird-appointment.service" ];
        serviceConfig = commonServiceConfig // {
          ExecStart = "${getExe' package "celery"} -A appointment.celery_app beat --loglevel=info --scheduler=redbeat.RedBeatScheduler";
          Restart = "on-failure";
        };
      };
    };

    services.nginx = mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.nginx.domain} = {
        forceSSL = true;
        enableACME = true;
        root = "${package}/share/thunderbird-appointment/frontend";
        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
          extraConfig = ''
            add_header Cache-Control "public, max-age=3600";
          '';
        };
        locations."/api/" = {
          proxyPass = "http://127.0.0.1:5000/";
          proxyWebsockets = true;
        };
        locations."/docs/" = {
          proxyPass = "http://127.0.0.1:5000/";
        };
      };
    };

    warnings =
      optionalString (cfg.settings.secretKey == "change-me-in-production-using-environmentFile")
        ''
          services.thunderbird-appointment.settings.secretKey is using default value. Please use an environmentFile with a strong APP_SECRET_KEY.
        '';
  };
}
