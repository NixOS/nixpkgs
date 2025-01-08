{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.postfix;
  inherit (lib)
    lib.mkOption
    types
    mkIf
    escapeShellArg
    concatStringsSep
    lib.optional
    ;
in
{
  port = 9154;
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-postfix-exporter" { };
    group = lib.mkOption {
      type = lib.types.str;
      description = ''
        Group under which the postfix exporter shall be run.
        It should match the group that is allowed to access the
        `showq` socket in the `queue/public/` directory.
        Defaults to `services.postfix.setgidGroup` when postfix is enabled.
      '';
    };
    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
    logfilePath = lib.mkOption {
      type = lib.types.path;
      default = "/var/log/postfix_exporter_input.log";
      example = "/var/log/mail.log";
      description = ''
        Path where Postfix writes log entries.
        This file will be truncated by this exporter!
      '';
    };
    showqPath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/postfix/queue/public/showq";
      example = "/var/spool/postfix/public/showq";
      description = ''
        Path where Postfix places its showq socket.
      '';
    };
    systemd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable reading metrics from the systemd journal instead of from a logfile
        '';
      };
      unit = lib.mkOption {
        type = lib.types.str;
        default = "postfix.service";
        description = ''
          Name of the postfix systemd unit.
        '';
      };
      slice = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Name of the postfix systemd slice.
          This overrides the {option}`systemd.unit`.
        '';
      };
      journalPath = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to the systemd journal.
        '';
      };
    };
  };
  serviceOpts = {
    after = lib.mkIf cfg.systemd.enable [ cfg.systemd.unit ];
    serviceConfig = {
      DynamicUser = false;
      # By default, each prometheus exporter only gets AF_INET & AF_INET6,
      # but AF_UNIX is needed to read from the `showq`-socket.
      RestrictAddressFamilies = [ "AF_UNIX" ];
      SupplementaryGroups = lib.mkIf cfg.systemd.enable [ "systemd-journal" ];
      ExecStart = ''
        ${lib.getExe cfg.package} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --postfix.showq_path ${lib.escapeShellArg cfg.showqPath} \
          ${lib.concatStringsSep " \\\n  " (
            cfg.extraFlags
            ++ lib.optional cfg.systemd.enable "--systemd.enable"
            ++ lib.optional cfg.systemd.enable (
              if cfg.systemd.slice != null then
                "--systemd.slice ${cfg.systemd.slice}"
              else
                "--systemd.unit ${cfg.systemd.unit}"
            )
            ++ lib.optional (
              cfg.systemd.enable && (cfg.systemd.journalPath != null)
            ) "--systemd.journal_path ${lib.escapeShellArg cfg.systemd.journalPath}"
            ++ lib.optional (!cfg.systemd.enable) "--postfix.logfile_path ${lib.escapeShellArg cfg.logfilePath}"
          )}
      '';
    };
  };
}
