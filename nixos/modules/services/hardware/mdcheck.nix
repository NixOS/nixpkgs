{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mdcheck;
in
{
  options.services.mdcheck = {
    enable = mkEnableOption (lib.mdDoc ''
      This option enables mdcheck timers that run regular full scrubs of the
      md devices.  These processes can also cause high I/O utilization; the
      configuration option `boot.kernel.sysctl."dev.raid.speed_limit_max"`
      can be used to limit the I/O utilization of the mdcheck processes.
    '');

    checkStart = mkOption {
      type = types.str;
      default = "Sun *-*-1..7 1:00:00";
      description = lib.mdDoc ''
        systemd OnCalendar expression for when to start an mdcheck operation.
        The default is to begin on the first Sunday of every month at 1am.
      '';
    };

    checkDuration = mkOption {
      type = types.str;
      default = "6 hours";
      description = lib.mdDoc ''
        When mdcheck starts to execute, this option controls how long should
        be spent on the scrub operation before stopping.  The default
        configuration is to scrub for 6 hours, then pause.

        The format of this string must be understood by `date --date`.
      '';
    };

    checkContinue = mkOption {
      type = types.str;
      default = "1:05:00";
      description = lib.mdDoc ''
        systemd OnCalendar expression for when to continue an in-progress
        mdcheck operation that was paused after `duration` time passed.  The
        default is to start at 1:05am every day.  If there is no in-progress
        operation then nothing will be started.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.timers.mdcheck_start = {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.checkStart;
    };
    systemd.timers.mdcheck_continue = {
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.checkContinue;
    };
    systemd.services.mdcheck_start.environment.MDADM_CHECK_DURATION = cfg.checkDuration;
    systemd.services.mdcheck_continue.environment.MDADM_CHECK_DURATION = cfg.checkDuration;
  };
}
