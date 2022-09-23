{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.unifi-poller;

  configFile = pkgs.writeText "prometheus-unifi-poller-exporter.json" (generators.toJSON {} {
    poller = { inherit (cfg.log) debug quiet; };
    unifi = { inherit (cfg) controllers; };
    influxdb.disable = true;
    prometheus = {
      http_listen = "${cfg.listenAddress}:${toString cfg.port}";
      report_errors = cfg.log.prometheusErrors;
    };
  });

in {
  port = 9130;

  extraOpts = {
    inherit (options.services.unifi-poller.unifi) controllers;
    log = {
      debug = mkEnableOption (lib.mdDoc "debug logging including line numbers, high resolution timestamps, per-device logs.");
      quiet = mkEnableOption (lib.mdDoc "startup and error logs only.");
      prometheusErrors = mkEnableOption (lib.mdDoc "emitting errors to prometheus.");
    };
  };

  serviceOpts.serviceConfig = {
    ExecStart = "${pkgs.unifi-poller}/bin/unifi-poller --config ${configFile}";
    DynamicUser = false;
  };
}
