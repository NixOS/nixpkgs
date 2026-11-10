{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.xray;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    optionalString
    ;
in
{
  port = 9550;

  extraOpts = {
    xrayEndpoint = mkOption {
      type = types.str;
      default = "127.0.0.1:8080";
      description = ''
        Xray gRPC API endpoint.
      '';
    };

    metricsPath = mkOption {
      type = types.str;
      default = "/scrape";
      description = ''
        Path under which to expose metrics.
      '';
    };

    scrapeTimeout = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Timeout in seconds for every individual scrape.
      '';
    };

    logPath = mkOption {
      type = types.str;
      default = "/var/log/xray/access.log";
      description = ''
        Path to Xray access log file. Set to empty string to disable user metrics.
      '';
    };

    logTimeWindow = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Time window in minutes for user metrics.
      '';
    };

    withUserMetrics = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Collect user metrics from the Xray access log.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-xray-exporter}/bin/xray-exporter \
          --listen ${cfg.listenAddress}:${toString cfg.port} \
          --metrics-path ${cfg.metricsPath} \
          --xray-endpoint ${cfg.xrayEndpoint} \
          --scrape-timeout ${toString cfg.scrapeTimeout} \
          ${optionalString (cfg.logPath != "") "--log-path ${cfg.logPath}"} \
          --log-time-window ${toString cfg.logTimeWindow} \
          ${optionalString cfg.withUserMetrics "--with-user-metrics"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
