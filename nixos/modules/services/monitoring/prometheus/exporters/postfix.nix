{ config, lib, pkgs, options }:

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
    systemd = {
      enable = mkEnableOption ''
        reading metrics from the systemd-journal instead of from a logfile
      '';
      unit = mkOption {
        type = types.str;
        default = "postfix.service";
        description = ''
          Name of the postfix systemd unit.
        '';
      };
      slice = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Name of the postfix systemd slice.
          This overrides the <option>systemd.unit</option>.
        '';
      };
      journalPath = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to the systemd journal.
        '';
      };
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      ExecStart = ''
        ${pkgs.prometheus-postfix-exporter}/bin/postfix_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --postfix.showq_path ${escapeShellArg cfg.showqPath} \
          ${concatStringsSep " \\\n  " (cfg.extraFlags
          ++ optional cfg.systemd.enable "--systemd.enable"
          ++ optional cfg.systemd.enable (if cfg.systemd.slice != null
                                          then "--systemd.slice ${cfg.systemd.slice}"
                                          else "--systemd.unit ${cfg.systemd.unit}")
          ++ optional (cfg.systemd.enable && (cfg.systemd.journalPath != null))
                       "--systemd.journal_path ${escapeShellArg cfg.systemd.journalPath}"
          ++ optional (!cfg.systemd.enable) "--postfix.logfile_path ${escapeShellArg cfg.logfilePath}")}
      '';
    };
  };
}
