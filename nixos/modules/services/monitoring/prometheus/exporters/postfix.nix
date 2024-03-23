{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.postfix;
in
{
  port = 9154;
  extraOpts = {
    group = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        Group under which the postfix exporter shall be run.
        It should match the group that is allowed to access the
        `showq` socket in the `queue/public/` directory.
        Defaults to `services.postfix.setgidGroup` when postfix is enabled.
      '';
    };
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = lib.mdDoc ''
        Path under which to expose metrics.
      '';
    };
    logfilePath = mkOption {
      type = types.path;
      default = "/var/log/postfix_exporter_input.log";
      example = "/var/log/mail.log";
      description = lib.mdDoc ''
        Path where Postfix writes log entries.
        This file will be truncated by this exporter!
      '';
    };
    showqPath = mkOption {
      type = types.path;
      default = "/var/lib/postfix/queue/public/showq";
      example = "/var/spool/postfix/public/showq";
      description = lib.mdDoc ''
        Path where Postfix places its showq socket.
      '';
    };
    systemd = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable reading metrics from the systemd journal instead of from a logfile
        '';
      };
      unit = mkOption {
        type = types.str;
        default = "postfix.service";
        description = lib.mdDoc ''
          Name of the postfix systemd unit.
        '';
      };
      slice = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Name of the postfix systemd slice.
          This overrides the {option}`systemd.unit`.
        '';
      };
      journalPath = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          Path to the systemd journal.
        '';
      };
    };
  };
  serviceOpts = {
    after = mkIf cfg.systemd.enable [ cfg.systemd.unit ];
    serviceConfig = {
      DynamicUser = false;
      # By default, each prometheus exporter only gets AF_INET & AF_INET6,
      # but AF_UNIX is needed to read from the `showq`-socket.
      RestrictAddressFamilies = [ "AF_UNIX" ];
      SupplementaryGroups = mkIf cfg.systemd.enable [ "systemd-journal" ];
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
