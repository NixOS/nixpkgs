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

    domain = lib.mkOption {
      type = lib.types.str;
      default = "_";
      description = "The nginx virtual host name to listen on. Set to `_` to forward all requests to bento.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The host to listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "The port to listen on.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open the port nginx is listening on for bentopdf.";
    };

    enableSSL = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable and enforce SSL. Requires separate ACME setup.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx.enable = true;

    services.nginx.virtualHosts."${cfg.domain}" = {
      forceSSL = lib.mkIf cfg.enableSSL true;
      enableACME = lib.mkIf cfg.enableSSL true;

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
        add_header X-XSS-Protection "1; mode=block" always;
      '';

      locations."~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$".extraConfig = ''
        expires 1y;
        add_header Cache-Control "public, immutable";
      '';
    };

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
  };
}
