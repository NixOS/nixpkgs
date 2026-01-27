{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.xray;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 9550;
  extraOpts = {
    xrayEndpoint = mkOption {
      type = types.str;
      default = "127.0.0.1:8080";
      description = ''
        Xray API endpoint.
      '';
    };
    logPath = mkOption {
      type = types.str;
      default = "/var/log/xray/access.log";
      description = ''
        Path to Xray access log file.
      '';
    };
    logTimeWindow = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Time window in minutes for user metrics.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-xray-exporter}/bin/xray-exporter \
          --xray-endpoint ${cfg.xrayEndpoint} \
          --listen ${cfg.listenAddress}:${toString cfg.port} \
          --log-path "${cfg.logPath}" \
          ${
            lib.optionalString (cfg.logTimeWindow != null) "--log-time-window ${toString cfg.logTimeWindow}"
          } \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
