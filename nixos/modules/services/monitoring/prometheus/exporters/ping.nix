{ config, lib, pkgs, options, ... }:


let
  cfg = config.services.prometheus.exporters.ping;
  inherit (lib) mkOption types concatStringsSep;

  settingsFormat = pkgs.formats.yaml {};
  configFile = settingsFormat.generate "config.yml" cfg.settings;
in
{
  port = 9427;
  extraOpts = {
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };

    settings = mkOption {
      type = settingsFormat.type;
      default = {};

      description = ''
        Configuration for ping_exporter, see
        <https://github.com/czerwonk/ping_exporter>
        for supported values.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      # ping-exporter needs `CAP_NET_RAW` to run as non root https://github.com/czerwonk/ping_exporter#running-as-non-root-user
      CapabilityBoundingSet = [ "CAP_NET_RAW" ];
      AmbientCapabilities = [ "CAP_NET_RAW" ];
      ExecStart = ''
        ${pkgs.prometheus-ping-exporter}/bin/ping_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --config.path="${configFile}" \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
