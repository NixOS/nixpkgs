{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.mainsail;
  moonraker = config.services.moonraker;
in
{
  options.services.mainsail = {
    enable = mkEnableOption "a modern and responsive user interface for Klipper";

    package = mkPackageOption pkgs "mainsail" { };

    hostName = mkOption {
      type = types.str;
      default = "localhost";
      description = "Hostname to serve mainsail on";
    };

    nginx = mkOption {
      type = types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
      default = { };
      example = literalExpression ''
        {
          serverAliases = [ "mainsail.''${config.networking.domain}" ];
        }
      '';
      description = "Extra configuration for the nginx virtual host of mainsail.";
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      upstreams.mainsail-apiserver.servers."${moonraker.address}:${toString moonraker.port}" = { };
      virtualHosts."${cfg.hostName}" = mkMerge [
        cfg.nginx
        {
          root = mkForce "${cfg.package}/share/mainsail";
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
              proxyPass = "http://mainsail-apiserver/websocket";
            };
            "~ ^/(printer|api|access|machine|server)/" = {
              proxyWebsockets = true;
              proxyPass = "http://mainsail-apiserver$request_uri";
            };
          };
        }
      ];
    };
  };
}
