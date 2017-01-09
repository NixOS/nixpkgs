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

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the nginx exporter.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.prometheus-nginx-exporter = {
      after = [ "network.target" "nginx.service" ];
      description = "Prometheus exporter for nginx metrics";
      unitConfig.Documentation = "https://github.com/discordianfish/nginx_exporter";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "nobody";
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        ExecStart = ''
          ${pkgs.prometheus-nginx-exporter}/bin/nginx_exporter \
            -nginx.scrape_uri '${cfg.scrapeUri}' \
            -telemetry.address ${cfg.listenAddress}:${toString cfg.port} \
            ${concatStringsSep " \\\n  " cfg.extraFlags}
        '';
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
