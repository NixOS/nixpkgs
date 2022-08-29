{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.fluidd;
  moonraker = config.services.moonraker;
in
{
  options.services.fluidd = {
    enable = mkEnableOption "Fluidd, a Klipper web interface for managing your 3d printer";

    package = mkOption {
      type = types.package;
      description = lib.mdDoc "Fluidd package to be used in the module";
      default = pkgs.fluidd;
      defaultText = literalExpression "pkgs.fluidd";
    };

    hostName = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc "Hostname to serve fluidd on";
    };

    nginx = mkOption {
      type = types.submodule
        (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
      default = { };
      example = literalExpression ''
        {
          serverAliases = [ "fluidd.''${config.networking.domain}" ];
        }
      '';
      description = lib.mdDoc "Extra configuration for the nginx virtual host of fluidd.";
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      upstreams.fluidd-apiserver.servers."${moonraker.address}:${toString moonraker.port}" = { };
      virtualHosts."${cfg.hostName}" = mkMerge [
        cfg.nginx
        {
          root = mkForce "${cfg.package}/share/fluidd/htdocs";
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
