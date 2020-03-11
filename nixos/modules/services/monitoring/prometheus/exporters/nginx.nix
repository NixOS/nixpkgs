{ config, lib, pkgs, options }:

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
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
    sslVerify = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to perform certificate verification for https.
      '';
    };
    constLabels = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "label1=value1"
        "label2=value2"
      ];
      description = ''
        A list of constant labels that will be used in every metric.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-nginx-exporter}/bin/nginx-prometheus-exporter \
          --nginx.scrape-uri '${cfg.scrapeUri}' \
          --nginx.ssl-verify ${toString cfg.sslVerify} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --prometheus.const-labels ${concatStringsSep "," cfg.constLabels} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
  imports = [
    (mkRenamedOptionModule [ "telemetryEndpoint" ] [ "telemetryPath" ])
    (mkRemovedOptionModule [ "insecure" ] ''
      This option was replaced by 'prometheus.exporters.nginx.sslVerify'.
    '')
    ({ options.warnings = options.warnings; options.assertions = options.assertions; })
  ];
}
