{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.raid.swraid.monitor;
in
{
  options.hardware.raid.swraid.monitor = {
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

    systemd.services.mdcheck_start = {
      description = "MD array scrubbing";
      wants = [ "mdcheck_continue.timer" ];
      environment.MDADM_CHECK_DURATION = cfg.checkDuration;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.mdadm}/bin/mdcheck --duration \${MDADM_CHECK_DURATION}";
      };
    };

    systemd.timers.mdcheck_start = {
      description = "MD array scrubbing";
      wantedBy = [ "timers.target" ];
      partOf = [ "mdcheck_start.service" ];
      # upstream mdadm has an `Also` to ensure that mdcheck_continue is
      # installed when this unit is installed; not necessary here because
      # they're tied together through nix config.
      timerConfig = {
        OnCalendar = cfg.checkStart;
        Unit = "mdcheck_start.service";
      };
    };

    systemd.services.mdcheck_continue = {
      description = "MD array scrubbing - continuation";
      wants = [ "mdcheck_continue.timer" ];
      environment.MDADM_CHECK_DURATION = cfg.checkDuration;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.mdadm}/bin/mdcheck --continue --duration \${MDADM_CHECK_DURATION}";
      };
    };

    systemd.timers.mdcheck_continue = {
      description = "MD array scrubbing - continuation";
      unitConfig.ConditionPathExistsGlob = "/var/lib/mdcheck/MD_UUID_*";
      wantedBy = [ "timers.target" ];
      partOf = [ "mdcheck_continue.service" ];
      timerConfig = {
        OnCalendar = cfg.checkContinue;
        Unit = "mdcheck_continue.service";
      };
    };
  };
}
