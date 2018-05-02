{ config, lib, pkgs }:

with lib;

let
  cfg = config.services.prometheus.exporters.nginx;
in
{
  port = 9113;
  extraOpts = {
    scrapeUri = mkOption {
      type = types.str;
      default = "http://localhost/nginx_status";
      description = ''
        Address to access the nginx status page.
        Can be enabled with services.nginx.statusPage = true.
      '';
    };
    telemetryEndpoint = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
    insecure = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Ignore server certificate if using https.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = true;
      ExecStart = ''
        ${pkgs.prometheus-nginx-exporter}/bin/nginx_exporter \
          --nginx.scrape_uri '${cfg.scrapeUri}' \
          --telemetry.address ${cfg.listenAddress}:${toString cfg.port} \
          --telemetry.endpoint ${cfg.telemetryEndpoint} \
          --insecure ${toString cfg.insecure} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
