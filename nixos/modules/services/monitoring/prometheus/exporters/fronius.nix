{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.fronius;
in
{
  port = 8080;
  extraOpts = {
    symo = {
      url = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Target base URL of Fronius Symo device. (default "http://symo.ip.or.hostname")
        '';
      };
      enable-archive = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          Enable/disable scraping of archive data (default true), at least one of archive/power-flow has to be enabled
        '';
        default = true;
      };
      enable-power-flow = mkOption {
        type = types.bool;
        description = lib.mdDoc ''
          Enable/disable scraping of power flow data (default true), at least one of archive/power-flow has to be enabled
        '';
        default = true;
      };
      header = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          List of "key: value" headers to append to the requests going to Fronius Symo. Example: --symo.header "authorization=Basic <base64>".
        '';
        default = null;
      };
      timeout = mkOption {
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          Timeout in seconds when collecting metrics from Fronius Symo. Should not be larger than the scrape interval. (default 5)
        '';
        default = "5s";
      };
    };
    log.level = mkOption {
      type = types.nullOr types.str;
      description = lib.mdDoc ''
        Logging level. (default "info")
      '';
      default = "info";
    };
  };
  serviceOpts = {
    serviceConfig = {
      Environment = [
        ## IP Address to bind to listen for Prometheus scrapes.
        "BIND_ADDR=${cfg.listenAddress}:${toString cfg.port}"
        ## Target URL of Fronius Symo device.
        "SYMO__URL=${cfg.symo.url}"
        ## Enable/disable scraping of archive data
        "SYMO__ENABLE_ARCHIVE=${lib.boolToString cfg.symo.enable-archive}"
        ## Enable/disable scraping of power flow data
        "SYMO__ENABLE_POWER_FLOW=${lib.boolToString cfg.symo.enable-power-flow}"
      ]
        ## Comma-separated List of "key: value" headers to append to the requests going to Fronius Symo. Example: "authorization=Basic <base64>".
        ++ lib.optional (cfg.symo.header != null) "SYMO__HEADER=${cfg.symo.header}"
        ## Logging level.
        ++ lib.optional (cfg.log.level != null) "LOG__LEVEL=${cfg.log.level}"
        ## Timeout in seconds when collecting metrics from Fronius Symo. Should not be larger than the scrape interval.
        ++ lib.optional (cfg.symo.timeout != null) "SYMO__TIMEOUT=${cfg.symo.timeout}"
      ;
      ExecStart = ''
        ${pkgs.prometheus-fronius-exporter}/bin/fronius-exporter
      '';
    };
  };
}
