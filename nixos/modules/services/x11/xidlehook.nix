{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.xidlehook;
in {
  options = {
    services.xserver.xidlehook = {
      enable = mkEnableOption "xidlehook";
      timers = mkOption {
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
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ xidlehook ];
    systemd.user.services.xidlehook = {
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
    assertions = (map (timer: {
      assertion = builtins.substring 0 1 timer.command == "/";
      message = "Please specify canonical paths for `services.xserver.xidlehook.timers` commands";
    }) cfg.timers) ++ (map (timer: {
      assertion = (timer.canceller or "") != "" -> builtins.substring 0 1 timer.canceller == "/";
      message = "Please specify canonical paths for `services.xserver.xidlehook.timers` cancellers";
    }) cfg.timers);
  };
}
