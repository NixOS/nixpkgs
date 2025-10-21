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
        To use the "simple mode" variant of bentopdf, which removes all socials, marketing and explanatory texts, set this option to `pkgs.bentopdf.overrideAttrs { SIMPLE_MODE = true; }`.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The host to listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4152;
      description = "The port nginx is listening on for bentopdf.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the port nginx is listening on for bentopdf.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.enable = true;

    services.nginx.virtualHosts."bentopdf" = {
      listen = [
        {
          addr = cfg.host;
          port = cfg.port;
        }
      ];

      root = "${cfg.package}";

      locations."/".extraConfig = ''
        try_files $uri $uri/ /index.html;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
      '';

      locations."~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$".extraConfig = ''
        expires 1y;
        add_header Cache-Control "public, immutable";
      '';
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
