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

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Liberaforms service port.";
    };

    openPorts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the ports in the firewall";
    };

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

    reverseProxy = {
      enable = lib.mkEnableOption "a HTTP reverse proxy for LiberaForms";
      host = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "liberaforms.localdomain";
        description = ''
          The fully qualified domain name to bind to. Sets `services.liberaforms.settings.BASE_URL`.

          This is required when using `services.liberaforms.reverseProxy.enable = true`.
        '';
      };
      ssl = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        example = true;
        description = ''
          Whether to enable SSL for the reverse proxy.

          This is required when using `services.liberaforms.reverseProxy.enable = true`.
        '';
      };
      webserver = lib.mkOption {
        type = lib.types.attrTag {
          nginx = lib.mkOption {
            type = lib.types.submodule ../web-servers/nginx/vhost-options.nix;
            default = { };
            description = ''
              Extra configuration for the nginx virtual host of LiberaForms.
              Set to `{ }` to use the default configuration.
            '';
          };
          caddy = lib.mkOption {
            type = lib.types.submodule (
              lib.modules.importApply ../web-servers/caddy/vhost-options.nix {
                cfg = config.services.caddy;
              }
            );
            default = { };
            description = ''
              Extra configuration for the caddy virtual host of LiberaForms.
              Set to `{ }` to use the default configuration.
            '';
          };
        };
        description = "The webserver to use as the reverse proxy.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.reverseProxy.enable -> ((cfg.reverseProxy.host != null) && (cfg.reverseProxy.ssl != null));
        message = "`services.liberaforms.reverseProxy.enable` requires `services.liberaforms.reverseProxy.host` and `services.liberaforms.reverseProxy.ssl` to be set.";
      }
    ];

    systemd.services.liberaforms = {
      description = "LiberaForms";
      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.target" ];
      after = [
        "network.target"
        "postgresql.target"
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

    services.liberaforms.settings.BASE_URL = lib.mkIf cfg.reverseProxy.enable (
      lib.mkDefault "${if cfg.reverseProxy.ssl then "https" else "http"}://${cfg.reverseProxy.host}"
    );

    services.caddy = lib.mkIf (cfg.reverseProxy.enable && cfg.reverseProxy.webserver ? caddy) {
      enable = true;
      virtualHosts.${cfg.settings.url} = lib.mkMerge [
        cfg.reverseProxy.webserver.caddy
        {
          hostName = lib.mkDefault cfg.settings.BASE_URL;
          extraConfig = ''
            header {
              Referrer-Policy "origin-when-cross-origin"
              X-Content-Type-Options "nosniff"
            }

            request_body {
              max_size 2MB
            }

            # Block /metrics (and anything under it) from the outside
            handle /metrics* {
              respond 404
            }

            handle_path /static/* {
              root * ${cfg.package}/share/liberaforms/liberaforms/static
              file_server
            }

            handle /favicon.ico {
              root * /var/lib/liberaforms/uploads/media/brand
              file_server
            }

            handle /logo.png {
              root * /var/lib/liberaforms/uploads/media/brand
              file_server
            }

            handle_path /file/media/* {
              root * /var/lib/liberaforms/uploads/media
              file_server
            }

            handle {
              @notembed not path_regexp /embed
              header @notembed X-Frame-Options "SAMEORIGIN"

              reverse_proxy 127.0.0.1:${toString cfg.port}
            }
          '';
        }
      ];
    };

    services.nginx = lib.mkIf (cfg.reverseProxy.enable && cfg.reverseProxy.webserver ? nginx) {
      enable = true;
      virtualHosts.${cfg.reverseProxy.host} = lib.mkMerge [
        cfg.reverseProxy.webserver.nginx
        {
          extraConfig = ''
            add_header Referrer-Policy "origin-when-cross-origin";
            add_header X-Content-Type-Options nosniff;

            client_max_body_size 2m;
          '';

          locations = {
            "/" = {
              recommendedProxySettings = true;
              proxyPass = "http://127.0.0.1:${toString cfg.port}";
              extraConfig = ''
                proxy_pass_header server;
                if ($request_uri !~ "/embed") {
                   add_header Referrer-Policy "origin-when-cross-origin";
                   add_header X-Content-Type-Options nosniff;
                   add_header X-Frame-Options "SAMEORIGIN";
                }
              '';
            };
            "/static/" = {
              alias = "${cfg.package}/share/liberaforms/liberaforms/static/";
            };
            "= /favicon.ico" = {
              alias = "/var/lib/liberaforms/uploads/media/brand/favicon.ico";
            };
            "= /logo.png" = {
              alias = "/var/lib/liberaforms/uploads/media/brand/logo.png";
            };
            "/file/media/" = {
              alias = "/var/lib/liberaforms/uploads/media/";
            };
            "/metrics" = {
              return = 404;
            };
          };
        }
        (lib.mkIf (cfg.reverseProxy.ssl != null) {
          forceSSL = lib.mkDefault cfg.reverseProxy.ssl;
        })
      ];
    };

    users = {
      groups.liberaforms = {
        members =
          lib.optional (
            cfg.reverseProxy.enable && cfg.reverseProxy.webserver ? nginx
          ) config.services.nginx.user
          ++ lib.optional (
            cfg.reverseProxy.enable && cfg.reverseProxy.webserver ? caddy
          ) config.services.caddy.user;
      };
      users.liberaforms = {
        isSystemUser = true;
        group = "liberaforms";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openPorts [ cfg.port ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openPorts [ cfg.port ];
  };
}
