{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.influxdb;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 9122;
  extraOpts = {
    sampleExpiry = mkOption {
      type = types.str;
      default = "5m";
      example = "10m";
      description = "How long a sample is valid for";
    };
    udpBindAddress = mkOption {
      type = types.str;
      default = ":9122";
      example = "192.0.2.1:9122";
      description = "Address on which to listen for udp packets";
    };
  };
  serviceOpts = {
    serviceConfig = {
      RuntimeDirectory = "prometheus-influxdb-exporter";
      ExecStart = ''
        ${pkgs.prometheus-influxdb-exporter}/bin/influxdb_exporter \
        --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
        --influxdb.sample-expiry ${cfg.sampleExpiry} ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
