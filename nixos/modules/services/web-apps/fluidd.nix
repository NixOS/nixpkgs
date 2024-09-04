{ config, lib, pkgs, ... }:
let
  cfg = config.services.fluidd;
  moonraker = config.services.moonraker;
in
{
  options.services.fluidd = {
    enable = lib.mkEnableOption "Fluidd, a Klipper web interface for managing your 3d printer";

    package = lib.mkPackageOption pkgs "fluidd" { };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Hostname to serve fluidd on";
    };

    nginx = lib.mkOption {
      type = lib.types.submodule
        (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
      default = { };
      example = lib.literalExpression ''
        {
          serverAliases = [ "fluidd.''${config.networking.domain}" ];
        }
      '';
      description = "Extra configuration for the nginx virtual host of fluidd.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      upstreams.fluidd-apiserver.servers."${moonraker.address}:${toString moonraker.port}" = { };
      virtualHosts."${cfg.hostName}" = lib.mkMerge [
        cfg.nginx
        {
          root = lib.mkForce "${cfg.package}/share/fluidd/htdocs";
          locations = {
            "/" = {
              index = "index.html";
              tryFiles = "$uri $uri/ /index.html";
            };
            "/index.html".extraConfig = ''
              add_header Cache-Control "no-store, no-cache, must-revalidate";
            '';
            "/websocket" = {
              proxyWebsockets = true;
              proxyPass = "http://fluidd-apiserver/websocket";
            };
            "~ ^/(printer|api|access|machine|server)/" = {
              proxyWebsockets = true;
              proxyPass = "http://fluidd-apiserver$request_uri";
            };
          };
        }
      ];
    };
  };
}
