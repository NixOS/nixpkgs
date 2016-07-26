{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.nginxExporter;
in {
  options = {
    services.prometheus.nginxExporter = {
      enable = mkEnableOption "prometheus nginx exporter";

      port = mkOption {
        type = types.int;
        default = 9113;
        description = ''
          Port to listen on.
        '';
      };

      listenAddress = mkOption {
        type = types.string;
        default = "0.0.0.0";
        description = ''
          Address to listen on.
        '';
      };

      scrapeUri = mkOption {
        type = types.string;
        default = "http://localhost/nginx_status";
        description = ''
          Address to access the nginx status page.
          Can be enabled with services.nginx.statusPage = true.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.prometheus-nginx-exporter = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "nginx.service" ];
      script = ''
        ${pkgs.prometheus-nginx-exporter.bin}/bin/nginx_exporter \
          -telemetry.address ${cfg.listenAddress}:${toString cfg.port} \
          -nginx.scrape_uri ${cfg.scrapeUri}
      '';
      serviceConfig = {
        User = "nobody";
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
      };
    };
  };
}
