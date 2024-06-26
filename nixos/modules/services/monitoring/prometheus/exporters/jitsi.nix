{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.jitsi;
  inherit (lib)
    mkOption
    types
    escapeShellArg
    concatStringsSep
    ;
in
{
  port = 9700;
  extraOpts = {
    url = mkOption {
      type = types.str;
      default = "http://localhost:8080/colibri/stats";
      description = ''
        Jitsi Videobridge metrics URL to monitor.
        This is usually /colibri/stats on port 8080 of the jitsi videobridge host.
      '';
    };
    interval = mkOption {
      type = types.str;
      default = "30s";
      example = "1min";
      description = ''
        How often to scrape new data
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-jitsi-exporter}/bin/jitsiexporter \
          -url ${escapeShellArg cfg.url} \
          -host ${cfg.listenAddress} \
          -port ${toString cfg.port} \
          -interval ${toString cfg.interval} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
