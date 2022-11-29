{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.unifi-poller;

  configFile = pkgs.writeText "prometheus-unifi-poller-exporter.json" (generators.toJSON {} {
    poller = { inherit (cfg.log) debug quiet; };
    unifi = { inherit (cfg) controllers; };
    influxdb.disable = true;
    datadog.disable = true; # workaround for https://github.com/unpoller/unpoller/issues/442
    prometheus = {
      http_listen = "${cfg.listenAddress}:${toString cfg.port}";
      report_errors = cfg.log.prometheusErrors;
    };
    inherit (cfg) loki;
  });

in {
  port = 9130;

  extraOpts = {
    inherit (options.services.unifi-poller.unifi) controllers;
    inherit (options.services.unifi-poller) loki;
    log = {
      debug = mkEnableOption (lib.mdDoc "debug logging including line numbers, high resolution timestamps, per-device logs.");
      quiet = mkEnableOption (lib.mdDoc "startup and error logs only.");
      prometheusErrors = mkEnableOption (lib.mdDoc "emitting errors to prometheus.");
    };
  };

  serviceOpts.serviceConfig = {
    ExecStart = "${pkgs.unifi-poller}/bin/unpoller --config ${configFile}";
    DynamicUser = false;
  };
}
