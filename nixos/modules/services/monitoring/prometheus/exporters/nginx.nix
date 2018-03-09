{ config, lib, pkgs }:

with lib;

let
  cfg = config.services.prometheus.exporters.nginx;
in
{
  port = 9113;
  extraOpts = {
    scrapeUri = mkOption {
      type = types.string;
      default = "http://localhost/nginx_status";
      description = ''
        Address to access the nginx status page.
        Can be enabled with services.nginx.statusPage = true.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = true;
      ExecStart = ''
        ${pkgs.prometheus-nginx-exporter}/bin/nginx_exporter \
          -nginx.scrape_uri '${cfg.scrapeUri}' \
          -telemetry.address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
