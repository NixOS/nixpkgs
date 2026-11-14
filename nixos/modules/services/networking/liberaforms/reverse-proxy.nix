{
  config,
  lib,
  ...
}:

let
  cfg = config.services.liberaforms;
in

{
  options.services.liberaforms = {
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
            type = lib.types.submodule ../../web-servers/nginx/vhost-options.nix;
            default = { };
            description = ''
              Extra configuration for the nginx virtual host of LiberaForms.
              Set to `{ }` to use the default configuration.
            '';
          };
          caddy = lib.mkOption {
            type = lib.types.submodule (
              lib.modules.importApply ../../web-servers/caddy/vhost-options.nix {
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

  config = lib.mkIf (cfg.enable && cfg.reverseProxy.enable) {
    assertions = [
      {
        assertion =
          cfg.reverseProxy.enable -> ((cfg.reverseProxy.host != null) && (cfg.reverseProxy.ssl != null));
        message = ''
          `services.liberaforms.reverseProxy.enable` requires `services.liberaforms.reverseProxy.host` and `services.liberaforms.reverseProxy.ssl` to be set.
        '';
      }
    ];

    services.liberaforms.settings.BASE_URL = lib.mkDefault "${
      if cfg.reverseProxy.ssl then "https" else "http"
    }://${cfg.reverseProxy.host}";

    services.caddy = lib.mkIf (cfg.reverseProxy.webserver ? caddy) {
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

    services.nginx = lib.mkIf (cfg.reverseProxy.webserver ? nginx) {
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

    users.groups.liberaforms.members =
      lib.optional (cfg.reverseProxy.webserver ? nginx) config.services.nginx.user
      ++ lib.optional (cfg.reverseProxy.webserver ? caddy) config.services.caddy.user;
  };
}
