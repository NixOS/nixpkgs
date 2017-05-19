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
            The script to use when locking the computer.
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
          default = "notify-send 'Locking in 10 seconds'";
          type = types.string;

          description = ''
            Notification script to be used to warn about the pending autolock.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ xautolock ];

      services.xserver.displayManager.sessionCommands = with builtins; with pkgs; ''
        ${xautolock}/bin/xautolock \
          ${concatStringsSep " \\\n" ([
            "-time ${toString(cfg.time)}"
            "-locker ${cfg.locker}"
          ] ++ optional cfg.enableNotifier (concatStringsSep " " [ 
            "-notify ${toString(cfg.notify)}"
            "-notifier \"${cfg.notifier}\""
          ]))} &
      '';
    };
  }
