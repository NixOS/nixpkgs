{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.json;
in
{
  port = 7979;
  extraOpts = {
    url = mkOption {
      type = types.str;
      description = ''
        URL to scrape JSON from.
      '';
    };
    configFile = mkOption {
      type = types.path;
      description = ''
        Path to configuration file.
      '';
    };
    listenAddress = {}; # not used
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-json-exporter}/bin/prometheus-json-exporter \
          --port ${toString cfg.port} \
          ${cfg.url} ${escapeShellArg cfg.configFile} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
