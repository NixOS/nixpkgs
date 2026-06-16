{
  config,
  lib,
  ...
}:

let
  cfg = config.services.liberaforms;
  stateDir = "/var/lib/liberaforms";
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
    };
  };

  config = lib.mkIf (cfg.enable && cfg.reverseProxy.enable) {
    assertions = [
      {
        assertion = (cfg.reverseProxy.host != null) && (cfg.reverseProxy.ssl != null);
        message = ''
          `services.liberaforms.reverseProxy.enable` requires `services.liberaforms.reverseProxy.host` and `services.liberaforms.reverseProxy.ssl` to be set.
        '';
      }
    ];

    services.liberaforms.settings.BASE_URL = lib.mkDefault "${
      if cfg.reverseProxy.ssl then "https" else "http"
    }://${cfg.reverseProxy.host}";

    # See:
    # https://codeberg.org/LiberaForms/server/src/branch/main/docs/nginx.example
    services.nginx = {
      enable = true;

      virtualHosts.${cfg.reverseProxy.host} = {
        enableACME = lib.mkDefault cfg.reverseProxy.ssl;
        forceSSL = lib.mkDefault cfg.reverseProxy.ssl;

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
            alias = "${stateDir}/uploads/media/brand/favicon.ico";
          };
          "= /logo.png" = {
            alias = "${stateDir}/uploads/media/brand/logo.png";
          };
          "/file/media/" = {
            alias = "${stateDir}/uploads/media/";
          };
          "/metrics" = {
            return = 404;
          };
        };
      };
    };

    security.acme = lib.mkIf cfg.reverseProxy.ssl {
      acceptTerms = lib.mkDefault true;
      defaults.email = lib.mkDefault cfg.settings.ROOT_USER;
    };

    users.groups.liberaforms.members = [
      config.services.nginx.user
    ];
  };
}
