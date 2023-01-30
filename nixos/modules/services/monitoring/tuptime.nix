{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.tuptime;

in {

  options.services.tuptime = {

    enable = mkEnableOption (lib.mdDoc "the total uptime service");

    timer = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to regularly log uptime to detect bad shutdowns.";
      };

      period = mkOption {
        type = types.str;
        default = "*:0/5";
        description = lib.mdDoc "systemd calendar event";
      };
    };
  };


  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.tuptime ];

    users = {
      groups._tuptime.members = [ "_tuptime" ];
      users._tuptime = {
        isSystemUser = true;
        group = "_tuptime";
        description = "tuptime database owner";
      };
    };

    systemd = {
      services = {

        tuptime = {
          description = "The total uptime service";
          documentation = [ "man:tuptime(1)" ];
          after = [ "time-sync.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            StateDirectory = "tuptime";
            Type = "oneshot";
            User = "_tuptime";
            RemainAfterExit = true;
            ExecStart = "${pkgs.tuptime}/bin/tuptime -q";
            ExecStop = "${pkgs.tuptime}/bin/tuptime -qg";
          };
        };

        tuptime-sync = mkIf cfg.timer.enable {
          description = "Tuptime scheduled sync service";
          serviceConfig = {
            Type = "oneshot";
            User = "_tuptime";
            ExecStart = "${pkgs.tuptime}/bin/tuptime -q";
          };
        };
      };

      timers.tuptime-sync = mkIf cfg.timer.enable {
        description = "Tuptime scheduled sync timer";
        # this timer should be started if the service is started
        # even if the timer was previously stopped
        wantedBy = [ "tuptime.service" "timers.target" ];
        # this timer should be stopped if the service is stopped
        partOf = [ "tuptime.service" ];
        timerConfig = {
          OnBootSec = "1min";
          OnCalendar = cfg.timer.period;
          Unit = "tuptime-sync.service";
        };
      };
    };
  };

  meta.maintainers = [ maintainers.evils ];

}
