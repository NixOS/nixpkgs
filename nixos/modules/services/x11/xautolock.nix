{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.xautolock;
in
  {
    options = {
      services.xserver.xautolock = {
        enable = mkEnableOption "xautolock";
        enableNotifier = mkEnableOption "xautolock.notify" // {
          description = ''
            Whether to enable the notifier feature of xautolock.
            This publishes a notification before the autolock.
          '';
        };

        time = mkOption {
          default = 15;
          type = types.int;

          description = ''
            Idle time to wait until xautolock locks the computer.
          '';
        };

        locker = mkOption {
          default = "xlock"; # default according to `man xautolock`
          example = "i3lock -i /path/to/img";
          type = types.string;

          description = ''
            The script to use when automatically locking the computer.
          '';
        };

        nowlocker = mkOption {
          default = null;
          example = "i3lock -i /path/to/img";
          type = types.nullOr types.string;

          description = ''
            The script to use when manually locking the computer with <command>xautolock -locknow</command>.
          '';
        };

        notify = mkOption {
          default = 10;
          type = types.int;

          description = ''
            Time (in seconds) before the actual lock when the notification about the pending lock should be published.
          '';
        };

        notifier = mkOption {
          default = null;
          example = literalExample ''
            "${pkgs.libnotify}/bin/notify-send \"Locking in 10 seconds\""
          '';
          type = types.nullOr types.string;

          description = ''
            Notification script to be used to warn about the pending autolock.
          '';
        };

        killer = mkOption {
          default = null; # default according to `man xautolock` is none
          example = "systemctl suspend";
          type = types.nullOr types.string;

          description = ''
            The script to use when nothing has happend for as long as <option>killtime</option>
          '';
        };

        killtime = mkOption {
          default = 20; # default according to `man xautolock`
          type = types.int;

          description = ''
            Minutes xautolock waits until it executes the script specified in <option>killer</option>
            (Has to be at least 10 minutes)
          '';
        };

        extraOptions = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "-detectsleep" ];
          description = ''
            Additional command-line arguments to pass to
            <command>xautolock</command>.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ xautolock ];
      systemd.user.services.xautolock = {
        description = "xautolock service";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = with lib; {
          ExecStart = strings.concatStringsSep " " ([
            "${pkgs.xautolock}/bin/xautolock"
            "-noclose"
            "-time ${toString cfg.time}"
            "-locker '${cfg.locker}'"
          ] ++ optionals cfg.enableNotifier [
            "-notify ${toString cfg.notify}"
            "-notifier '${cfg.notifier}'"
          ] ++ optionals (cfg.nowlocker != null) [
            "-nowlocker '${cfg.nowlocker}'"
          ] ++ optionals (cfg.killer != null) [
            "-killer '${cfg.killer}'"
            "-killtime ${toString cfg.killtime}"
          ] ++ cfg.extraOptions);
          Restart = "always";
        };
      };
      assertions = [
        {
          assertion = cfg.enableNotifier -> cfg.notifier != null;
          message = "When enabling the notifier for xautolock, you also need to specify the notify script";
        }
        {
          assertion = cfg.killer != null -> cfg.killtime >= 10;
          message = "killtime has to be at least 10 minutes according to `man xautolock`";
        }
      ];
    };
  }
