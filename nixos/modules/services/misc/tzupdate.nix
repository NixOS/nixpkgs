{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.tzupdate;
in
{
  options.services.tzupdate = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable the tzupdate timezone updating service. This provides
        a one-shot service which can be activated with systemctl to
        update the timezone.
      '';
    };

    package = lib.mkPackageOption pkgs "tzupdate" { };

    timer.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable the tzupdate timer to update the timezone automatically.
      '';
    };

    timer.interval = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      description = ''
        The interval at which the tzupdate timer should run. See
        {manpage}`systemd.time(7)` to understand the format.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # We need to have imperative time zone management for this to work.
    # This will give users an error if they have set an explicit time
    # zone, which is better than silently overriding it.
    time.timeZone = null;

    # We provide a one-shot service that runs at startup once network
    # interfaces are up, but we can’t ensure we actually have Internet access
    # at that point. It can also be run manually with `systemctl start tzupdate`.
    systemd.services.tzupdate = {
      description = "tzupdate timezone update service";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      script = ''
        timezone="$(${lib.getExe cfg.package} --print-only)"
        if [[ -n "$timezone" ]]; then
          echo "Setting timezone to '$timezone'"
          timedatectl set-timezone "$timezone"
        fi
      '';

      serviceConfig = {
        Type = "oneshot";
      };
    };

    systemd.timers.tzupdate = {
      enable = cfg.timer.enable;
      timerConfig = {
        OnStartupSec = "30s";
        OnCalendar = cfg.timer.interval;
        Persistent = true;
      };
      wantedBy = [ "timers.target" ];
    };
  };

  meta.maintainers = with lib.maintainers; [ doronbehar ];
}
