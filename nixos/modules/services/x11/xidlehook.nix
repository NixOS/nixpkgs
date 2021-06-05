{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.xidlehook;
in {
  options = {
    services.xserver.xidlehook = {
      enable = mkEnableOption "xidlehook";
      timers = mkOption {
        description = ''
          List of timers.

          Most other xidlehook options adjust the default value of this option;
          if this option is set directly, most other xidlehook options have no effect.
          This is done to maintain drop-in compatibility with the xautolock module
          for folks that already have xautolock set up the way they like it.
          If you don't have an existing xautolock config, you may prefer the
          simplicity of xidlehook's one-list-of-timers interface.
       '';
       # This is upstream's example: Dim the screen after 60 seconds, undim if user becomes active
       example = literalExample ''
          [
            {
              duration = 60;
              command = '''
                ''${pkgs.xorg.xrandr}/bin/xrandr --output "$(''${pkgs.xorg.xrandr}/bin/xrandr | ''${pkgs.gawk}/bin/awk '/primary/ { print $1 }')" --brightness .1
              ''';
              canceller = '''
                ''${pkgs.xorg.xrandr}/bin/xrandr --output "$(''${pkgs.xorg.xrandr}/bin/xrandr | ''${pkgs.gawk}/bin/awk '/primary/ { print $1 }')" --brightness 1
              ''';
            }
            # Undim & lock after 10 more seconds
            {
              duration = 10;
              command = '''
                ''${pkgs.xorg.xrandr}/bin/xrandr --output "$(''${pkgs.xorg.xrandr}/bin/xrandr | ''${pkgs.gawk}/bin/awk '/primary/ { print $1 }')" --brightness 1
                ''${pkgs.i3lock}/bin/i3lock
              ''';
            }
            # Finally, suspend an hour after it locks
            {
              duration = 3600;
              command = '''
                ''${pkgs.systemd}/bin/systemctl suspend
              ''';
            }
          ];
        '';
        # We use uniq here because conflicting definitions of the list of timers should
        # be brought to the attention of the user.  Because timer durations are relative
        # and because one timer's action often includes the previous timer's canceller,
        # there isn't a good way to automatically merge timer-lists.
        type = types.uniq (types.listOf (types.submodule {
          options = {
            duration = mkOption {
              description = ''
                The number of seconds of inactivity which should trigger this timer.
              '';
              type = types.int;
            };
            command = mkOption {
              description = ''
                The shell command invoked when the idle duration is reached.
              '';
              type = types.str;
            };
            canceller = mkOption {
              description = ''
                The shell command invoked when the user becomes active after
                the timer has gone off, but before the next timer (if any).
                Optional.
              '';
              type = types.str;
              default = "";
            };
          };
        }));
      };
      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = literalExample ''
          [ "--socket" "\''${XDG_RUNTIME_DIR}/xidlehook.socket" "--not-when-fullscreen" "--not-when-audio" ]
        '';
        description = ''
          Additional command-line arguments to pass to
          <command>xidlehook</command>.
        '';
      };


      # Options for drop-in compatibility with xautolock

      enableNotifier = mkEnableOption "xidlehook.notify" // {
        description = ''
          This publishes a notification before the autolock.

          This option is for xautolock-configuration compatibility and has no effect if
          services.xserver.xidlehook.timers is set directly.
        '';
      };

      time = mkOption {
        default = 15;
        type = types.int;

        description = ''
          Idle time (in minutes) to wait until xidlehook locks the computer.

          This option is for xautolock-configuration compatibility and has no effect if
          services.xserver.xidlehook.timers is set directly.
        '';
      };

      locker = mkOption {
        default = "${pkgs.xlockmore}/bin/xlock"; # default according to `man xautolock`
        example = literalExample ''
          "''${pkgs.i3lock}/bin/i3lock -i /path/to/img"
        '';
        type = types.str;

        description = ''
          The script to use when automatically locking the computer.

          This option is for xautolock-configuration compatibility and has no effect if
          services.xserver.xidlehook.timers is set directly.
        '';
      };

      notify = mkOption {
        default = 10;
        type = types.int;

        description = ''
          Time (in seconds) before the actual lock when the notification about the pending lock should be published.

          This option is for xautolock-configuration compatibility and has no effect if
          services.xserver.xidlehook.timers is set directly.
        '';
      };

      notifier = mkOption {
        default = null;
        example = literalExample ''
          "''${pkgs.libnotify}/bin/notify-send \"Locking in ''${toString cfg.notify} seconds\""
        '';
        type = types.nullOr types.str;

        description = ''
          Notification script to be used to warn about the pending autolock.

          This option is for xautolock-configuration compatibility and has no effect if
          services.xserver.xidlehook.timers is set directly.
        '';
      };

      killer = mkOption {
        default = null; # default according to `man xautolock` is none
        example = literalExample ''
          "''${pkgs.systemd}/bin/systemctl suspend"
        '';
        type = types.nullOr types.str;

        description = ''
          The script to use when nothing has happend for as long as <option>killtime</option>

          This option is for xautolock-configuration compatibility and has no effect if
          services.xserver.xidlehook.timers is set directly.
        '';
      };

      killtime = mkOption {
        default = 20; # default according to `man xautolock`
        type = types.int;

        description = ''
          Minutes xidlehook waits until it executes the script specified in <option>killer</option>

          This option is for xautolock-configuration compatibility and has no effect if
          services.xserver.xidlehook.timers is set directly.
        '';
      };
    };
  };

  config = {
    services.xserver.xidlehook.timers = mkDefault (
      (optional cfg.enableNotifier {
        duration = cfg.time * 60 - cfg.notify;
        command = cfg.notifier;
      }) ++ [{
        duration = if cfg.enableNotifier then cfg.notify else cfg.time * 60;
        command = cfg.locker;
      }] ++ (optional (cfg.killer != null) {
        duration = (cfg.killtime - cfg.time) * 60;
        command = cfg.killer;
      }));

    environment.systemPackages = optional cfg.enable pkgs.xidlehook;

    systemd.user.services.xidlehook = mkIf cfg.enable {
      description = "xidlehook service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = strings.concatStringsSep " "
          ([ "${pkgs.xidlehook}/bin/xidlehook" ] ++ cfg.extraOptions ++ flatten
            (map (timer: [
              "--timer"
              (toString timer.duration)
              (escapeShellArg timer.command)
              (escapeShellArg (timer.canceller or ""))
            ]) cfg.timers));
        Restart = "always";
      };
    };

    assertions = optionals cfg.enable (map (timer: {
      assertion = builtins.substring 0 1 timer.command == "/";
      message = "Please specify canonical paths for `services.xserver.xidlehook.timers` commands";
    }) cfg.timers) ++ (map (timer: {
      assertion = (timer.canceller or "") != "" -> builtins.substring 0 1 timer.canceller == "/";
      message = "Please specify canonical paths for `services.xserver.xidlehook.timers` cancellers";
    }) cfg.timers) ++ [{
      assertion = cfg.enableNotifier -> cfg.notifier != null;
      message = "When enabling the notifier for xidlehook, you also need to specify the notify script";
    }] ++ (lib.forEach [ "locker" "notifier" "killer" ]
      (option: {
        assertion = cfg.${option} != null -> builtins.substring 0 1 cfg.${option} == "/";
        message = "Please specify a canonical path for `services.xserver.xidlehook.${option}`";
      })
    );
  };
}
