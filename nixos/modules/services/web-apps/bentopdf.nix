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

    domain = lib.mkOption {
      description = "Domain to use for the virtual host.";
      type = lib.types.str;
    };

    nginx = {
      enable = lib.mkEnableOption "a virtualhost to serve bentopdf through nginx";

      virtualHost = lib.mkOption {
        type = lib.types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
        default = { };
        example = lib.literalExpression ''
          {
            serverAliases = [ "bentopdf.''${config.networking.domain}" ];
          }
        '';
        description = "Extra configuration for the nginx virtual host of bentopdf.";
      };
    };

    caddy = {
      enable = lib.mkEnableOption "a virtualhost to serve bentopdf through caddy";

      virtualHost = lib.mkOption {
        type = lib.types.submodule (
          import ../web-servers/caddy/vhost-options.nix { cfg = config.services.caddy; }
        );
        default = { };
        example = lib.literalExpression ''
          {
            serverAliases = [ "bentopdf.''${config.networking.domain}" ];
          }
        '';
        description = "Extra configuration for the caddy virtual host of bentopdf.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.domain}" = lib.mkMerge [
        cfg.nginx.virtualHost
        {
          root = lib.mkForce "${cfg.package}";

          locations."/" = {
            index = "index.html";
            extraConfig = ''
              try_files $uri $uri/ /index.html;
            '';
          };

          locations."~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$".extraConfig = ''
            expires 1y;
            add_header Cache-Control "public, immutable";
          '';
        }
      ];
    };

    services.caddy = lib.mkIf cfg.caddy.enable {
      enable = lib.mkDefault true;
      virtualHosts."${cfg.domain}" = lib.mkMerge [
        cfg.caddy.virtualHost
        {
          hostName = lib.mkForce cfg.domain;
          extraConfig = ''
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
        }
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [
    charludo
    stunkymonkey
  ];
}
