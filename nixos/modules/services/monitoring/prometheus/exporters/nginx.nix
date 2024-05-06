{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.nginx;
  inherit (lib)
    mkOption
    types
    mkMerge
    mkRemovedOptionModule
    mkRenamedOptionModule
    mkIf
    concatStringsSep
    ;
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
  serviceOpts = mkMerge ([{
    environment.CONST_LABELS = concatStringsSep "," cfg.constLabels;
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-nginx-exporter}/bin/nginx-prometheus-exporter \
          --nginx.scrape-uri='${cfg.scrapeUri}' \
          --${lib.optionalString (!cfg.sslVerify) "no-"}nginx.ssl-verify \
          --web.listen-address=${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path=${cfg.telemetryPath} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  }] ++ [(mkIf config.services.nginx.enable {
    after = [ "nginx.service" ];
    requires = [ "nginx.service" ];
  })]);
  imports = [
    (mkRenamedOptionModule [ "telemetryEndpoint" ] [ "telemetryPath" ])
    (mkRemovedOptionModule [ "insecure" ] ''
      This option was replaced by 'prometheus.exporters.nginx.sslVerify'.
    '')
    ({ options.warnings = options.warnings; options.assertions = options.assertions; })
  ];
}
