{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.liberaforms;

  pythonVars = pkgs.formats.pythonVars { };
  settingsFile = pythonVars.generate "dotenv" cfg.settings;
in

{
  options.services.liberaforms = {
    enable = lib.mkEnableOption "LiberaForms";
    package = lib.mkPackageOption pkgs "liberaforms" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = pythonVars.type;

        options = {
          BASE_URL = lib.mkOption {
            type = lib.types.str;
            example = "https://mydomain.com";
            description = "Base URL for the LiberaForms instance.";
          };

          ROOT_USER = lib.mkOption {
            type = lib.types.str;
            example = "admin@example.com";
            description = "Email address of the root/admin user.";
          };

          DEFAULT_LANGUAGE = lib.mkOption {
            type = lib.types.enum [
              "ca-ES"
              "cs-CZ"
              "de-DE"
              "en-US"
              "es-ES"
              "eu-ES"
              "fr-FR"
              "gl-ES"
              "ru-RU"
              "ta-IN"
              "uk-UA"
              "zh-CN"
            ];
            default = "en-US";
            description = "Default language for the interface.";
          };

          # TODO: read from file
          SECRET_KEY = lib.mkOption {
            type = lib.types.str;
            description = ''
              Secret key for session management and CSRF protection.
              Generate with: python3 -c 'import secrets; print(secrets.token_hex(32))'.
            '';
          };

          TMP_DIR = lib.mkOption {
            type = lib.types.str;
            default = "/var/cache/liberaforms";
            description = "Temporary directory for file operations.";
          };

          E2EE_MODE = lib.mkOption {
            type = lib.types.enum [
              "DISABLED"
              "AVAILABLE"
              "ENABLED_BY_DEFAULT"
              "REQUIRED"
            ];
            default = "AVAILABLE";
            description = ''
              End-to-End Encryption mode for forms.

              - **DISABLED**: E2EE not available
              - **AVAILABLE**: Users may enable E2EE per form
              - **ENABLED_BY_DEFAULT**: E2EE enabled by default, users may decline
              - **REQUIRED**: E2EE required, unencrypted forms cannot be created
            '';
          };

          TOKEN_EXPIRATION = lib.mkOption {
            type = lib.types.int;
            default = 604800;
            example = 86400;
            description = ''
              Maximum valid age for password resets and invitations, in seconds.
              86400 = 24h, 604800 = 7 days.
            '';
          };

          # TODO: `flask cryptokey create`
          CRYPTO_KEY = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
              Encryption key for form data. Required if E2EE_MODE is not DISABLED.
            '';
          };

          SECONDS_TO_POST = lib.mkOption {
            type = lib.types.int;
            default = 20;
            description = ''
              Client-side spam prevention.
              Forms submitted before this many seconds must wait. Set to 0 to disable.
            '';
          };

          SESSION_TYPE = lib.mkOption {
            type = lib.types.enum [
              "filesystem"
              "memcached"
              "sqlalchemy"
            ];
            default = "filesystem";
            description = ''
              Session storage backend.
              Using 'filesystem' is good for most installations, while 'sqlalchemy' is good for development and smaller installations.
              Using 'memcached' is good for larger installations, but requires a Memcached server.
            '';
          };

          ENABLE_CONFIRMATION_EMAIL = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable confirmation emails for form submissions.";
          };

          ENABLE_UPLOADS = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable file uploads on forms.";
          };

          ENABLE_REMOTE_STORAGE = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable remote storage (S3-compatible) for uploads.";
          };

          TOTAL_UPLOADS_LIMIT = lib.mkOption {
            type = lib.types.str;
            default = "1 GB";
            description = "Total storage limit for all uploads combined.";
          };

          DEFAULT_USER_UPLOADS_LIMIT = lib.mkOption {
            type = lib.types.str;
            default = "50 MB";
            description = "Default storage limit per user.";
          };

          MAX_MEDIA_SIZE = lib.mkOption {
            type = lib.types.int;
            default = 512000;
            description = "Maximum media file size in bytes (512000 = 500 KiB).";
          };

          MAX_ATTACHMENT_SIZE = lib.mkOption {
            type = lib.types.int;
            default = 1572864;
            description = "Maximum attachment file size in bytes (1572864 = 1.5 MiB).";
          };

          LOG_DIR = lib.mkOption {
            type = lib.types.str;
            default = "/var/log/liberaforms";
            description = "Directory where logs will be saved.";
          };

          DEFAULT_TIMEZONE = lib.mkOption {
            type = lib.types.str;
            default = "Europe/Madrid";
            description = ''
              Default timezone.
              See [assets/timezones.txt](https://codeberg.org/LiberaForms/server/src/branch/main/assets/timezones.txt) for valid options.
            '';
          };

          ENABLE_RSS_FEED = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable RSS feed for public forms.";
          };

          ENABLE_PROMETHEUS_METRICS = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Prometheus /metrics endpoint for monitoring.";
          };

          FLASK_CONFIG = lib.mkOption {
            type = lib.types.enum [
              "production"
              "development"
            ];
            default = "production";
            description = "Flask application configuration mode.";
          };

          FLASK_DEBUG = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable Flask debug mode.";
          };

          LOG_LEVEL = lib.mkOption {
            type = lib.types.enum [
              "CRITICAL"
              "ERROR"
              "WARNING"
              "INFO"
              "DEBUG"
            ];
            default = "INFO";
            description = ''
              Logging level.

              CRITICAL:50 <- ERROR:40 <- WARNING:30 <- INFO:20 <- DEBUG:10.
            '';
          };

          LOG_SERVER_PORT = lib.mkOption {
            type = lib.types.int;
            default = 9000;
            description = "Port for the log server.";
          };
        };
      };
      default = { };
      description = ''
        Configuration for LiberaForms, which will be passed as environment variables.
        See <https://codeberg.org/LiberaForms/server/src/branch/main/dotenv.example>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.liberaforms = {
      description = "LiberaForms";
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [
        "network.target"
        "postgresql.service"
      ];
      environment = {
        PGHOST = "/run/postgresql";
        PGDATABASE = "liberaforms";
        ENV_FILE = settingsFile;
        UPLOADS_DIR = "/var/lib/liberaforms/uploads";
      };
      serviceConfig = {
        User = "liberaforms";
        Group = "liberaforms";
        ExecStart = lib.getExe cfg.package;
        CacheDirectory = "liberaforms";
        LogsDirectory = "liberaforms";
        StateDirectory = "liberaforms";
        WorkingDirectory = "%S/liberaforms";
      };
      preStart = ''
        ${lib.getExe' cfg.package "liberaforms-flask"} database upgrade
      '';
    };

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "liberaforms";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "liberaforms" ];
    };

    users = {
      groups.liberaforms = { };
      users.liberaforms = {
        isSystemUser = true;
        group = "liberaforms";
      };
    };
  };
}
