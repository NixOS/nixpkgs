{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.bentopdf;
in
{
  options.services.bentopdf = {
    enable = lib.mkEnableOption "bentopdf Privacy First PDF Toolkit";

    package = lib.mkPackageOption pkgs "bentopdf" {
      extraDescription = ''
        To use the "normal mode" variant of bentopdf, which includes all socials, marketing and explanatory texts, set this option to `pkgs.bentopdf.override { simpleMode = false; }`.
      '';
    };

    virtualHost = {
      nginx.enable = lib.mkEnableOption "a virtualhost to serve bentopdf through nginx";
      caddy.enable = lib.mkEnableOption "a virtualhost to serve bentopdf through caddy";

      domain = lib.mkOption {
        description = ''
          Domain to use for the virtual host.

          This can be used to change nginx options like
          ```nix
          services.nginx.virtualHosts."$\{config.services.bentopdf.virtualHost.domain}".listen = [ ... ]
          ```
          or
          ```nix
          services.nginx.virtualHosts."example.com".listen = [ ... ]
          ```
        '';
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # The nginx config is derived from: https://github.com/alam00000/bentopdf/blob/d9561d79b9eef5b0853dc8bfb3ef7cc9323a47c7/docs/self-hosting/nginx.md
    services.nginx = lib.mkIf cfg.virtualHost.nginx.enable {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.virtualHost.domain}" = {
        root = "${cfg.package}";

        locations."/" = {
          index = "index.html";
          extraConfig = ''
            try_files $uri $uri/ /index.html;
          '';
        };

        locations."~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$".extraConfig = ''
          expires 1y;
          add_header Cache-Control "public, immutable";
        '';
      };
    };

    # adapted from the nginx config
    services.caddy = lib.mkIf cfg.virtualHost.caddy.enable {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.virtualHost.domain}".extraConfig = ''
        root * ${cfg.package}
        try_files {path} /index.html
        file_server

        @static {
          path_regexp static \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$
        }
        handle @static {
          header {
            Cache-Control "public, immutable"
          }
          header Cache-Control max-age=31536000
        }
      '';
    };
  };
  meta.maintainers = with lib.maintainers; [
    charludo
    stunkymonkey
  ];
}
