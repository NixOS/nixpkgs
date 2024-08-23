{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.shelly;
  inherit (lib) mkOption types;
in
{
  port = 9784;
  extraOpts = {
    metrics-file = mkOption {
      type = types.path;
      description = ''
        Path to the JSON file with the metric definitions
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-shelly-exporter}/bin/shelly_exporter \
          -metrics-file ${cfg.metrics-file} \
          -listen-address ${cfg.listenAddress}:${toString cfg.port}
      '';
    };
  };
}
