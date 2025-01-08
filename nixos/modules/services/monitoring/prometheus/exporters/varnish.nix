{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.varnish;
in
{
  port = 9131;
  extraOpts = {
    noExit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Do not exit server on Varnish scrape errors.
      '';
    };
    withGoMetrics = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Export go runtime and http handler metrics.
      '';
    };
    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable verbose logging.
      '';
    };
    raw = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable raw stdout logging without timestamps.
      '';
    };
    varnishStatPath = lib.mkOption {
      type = lib.types.str;
      default = "varnishstat";
      description = ''
        Path to varnishstat.
      '';
    };
    instance = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.services.varnish.stateDir;
      defaultText = lib.literalExpression "config.services.varnish.stateDir";
      description = ''
        varnishstat -n value.
      '';
    };
    healthPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Path under which to expose healthcheck. Disabled unless configured.
      '';
    };
    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
  };
  serviceOpts = {
    path = [ config.services.varnish.package ];
    serviceConfig = {
      RestartSec = lib.mkDefault 1;
      DynamicUser = false;
      ExecStart = ''
        ${pkgs.prometheus-varnish-exporter}/bin/prometheus_varnish_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --varnishstat-path ${lib.escapeShellArg cfg.varnishStatPath} \
          ${lib.concatStringsSep " \\\n  " (
            cfg.extraFlags
            ++ lib.optional (cfg.healthPath != null) "--web.health-path ${cfg.healthPath}"
            ++ lib.optional (cfg.instance != null) "-n ${lib.escapeShellArg cfg.instance}"
            ++ lib.optional cfg.noExit "--no-exit"
            ++ lib.optional cfg.withGoMetrics "--with-go-metrics"
            ++ lib.optional cfg.verbose "--verbose"
            ++ lib.optional cfg.raw "--raw"
          )}
      '';
    };
  };
}
