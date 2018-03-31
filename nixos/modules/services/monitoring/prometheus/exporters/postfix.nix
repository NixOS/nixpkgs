{ config, lib, pkgs }:

with lib;

let
  cfg = config.services.prometheus.exporters.postfix;
in
{
  port = 9154;
  extraOpts = {
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
    logfilePath = mkOption {
      type = types.path;
      default = "/var/log/postfix_exporter_input.log";
      example = "/var/log/mail.log";
      description = ''
        Path where Postfix writes log entries.
        This file will be truncated by this exporter!
      '';
    };
    showqPath = mkOption {
      type = types.path;
      default = "/var/spool/postfix/public/showq";
      example = "/var/lib/postfix/queue/public/showq";
      description = ''
        Path where Postfix places it's showq socket.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-postfix-exporter}/bin/postfix_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
