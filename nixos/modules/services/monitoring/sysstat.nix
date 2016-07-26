{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.sysstat;
in {
  options = {
    services.sysstat = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable sar system activity collection.
        '';
      };

      collect-frequency = mkOption {
        default = "*:00/10";
        description = ''
          OnCalendar specification for sysstat-collect
        '';
      };

      collect-args = mkOption {
        default = "1 1";
        description = ''
          Arguments to pass sa1 when collecting statistics
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.sysstat = {
      description = "Resets System Activity Logs";
      wantedBy = [ "multi-user.target" ];
      preStart = "test -d /var/log/sa || mkdir -p /var/log/sa";

      serviceConfig = {
        User = "root";
        RemainAfterExit = true;
        Type = "oneshot";
        ExecStart = "${pkgs.sysstat}/lib/sa/sa1 --boot";
      };
    };

    systemd.services.sysstat-collect = {
      description = "system activity accounting tool";
      unitConfig.Documentation = "man:sa1(8)";

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.sysstat}/lib/sa/sa1 ${cfg.collect-args}";
      };
    };

    systemd.timers.sysstat-collect = {
      description = "Run system activity accounting tool on a regular basis";
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.collect-frequency;
    };

    systemd.services.sysstat-summary = {
      description = "Generate a daily summary of process accounting";
      unitConfig.Documentation = "man:sa2(8)";

      serviceConfig = {
        Type = "oneshot";
        User = "root";
        ExecStart = "${pkgs.sysstat}/lib/sa/sa2 -A";
      };
    };

    systemd.timers.sysstat-summary = {
      description = "Generate summary of yesterday's process accounting";
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "00:07:00";
    };
  };
}
