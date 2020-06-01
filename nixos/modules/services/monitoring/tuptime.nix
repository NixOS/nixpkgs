{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.tuptime;

in {

  options.services.tuptime = {

    enable = mkEnableOption "the total uptime service";

    timer = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to regularly log uptime to detect bad shutdowns.";
      };

      period = mkOption {
        type = types.str;
        default = "*:0/5";
        description = "systemd calendar event";
      };
    };
  };


  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.tuptime ];

    users.users.tuptime.description = "tuptime database owner";

    systemd = {
      services = {

        tuptime = {
          description = "the total uptime service";
          documentation = [ "man:tuptime(1)" ];
          after = [ "time-sync.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            StateDirectory = "tuptime";
            Type = "oneshot";
            User = "tuptime";
            RemainAfterExit = true;
            ExecStart = "${pkgs.tuptime}/bin/tuptime -x";
            ExecStop = "${pkgs.tuptime}/bin/tuptime -xg";
          };
        };

        tuptime-oneshot = mkIf cfg.timer.enable {
          description = "the tuptime scheduled execution unit";
          serviceConfig = {
            StateDirectory = "tuptime";
            Type = "oneshot";
            User = "tuptime";
            ExecStart = "${pkgs.tuptime}/bin/tuptime -x";
          };
        };
      };

      timers.tuptime = mkIf cfg.timer.enable {
        description = "the tuptime scheduled execution timer";
        # this timer should be started if the service is started
        # even if the timer was previously stopped
        wantedBy = [ "tuptime.service" "timers.target" ];
        # this timer should be stopped if the service is stopped
        partOf = [ "tuptime.service" ];
        timerConfig = {
          OnBootSec = "1min";
          OnCalendar = cfg.timer.period;
          Unit = "tuptime-oneshot.service";
        };
      };
    };
  };

  meta.maintainers = [ maintainers.evils ];

}
