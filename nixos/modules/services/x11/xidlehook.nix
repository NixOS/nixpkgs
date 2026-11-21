{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.xserver.xidlehook;

  timerType = lib.types.submodule {
    options = {
      duration = lib.mkOption {
        type = lib.types.ints.positive;
        example = 300;
        description = ''
          Number of seconds of inactivity after the preceding timer before this
          timer is activated.
        '';
      };

      command = mkOption {
        default = "${pkgs.slock}/bin/slock"; # default according to README
        defaultText = literalExpression ''"''${pkgs.slock}/bin/slock"'';
        example = literalExpression ''"''${pkgs.i3lock}/bin/i3lock -i /path/to/img"'';
        type = types.str;

        description = ''
          The script to use when automatically locking the computer.
        '';
      };

      canceller = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "${pkgs.xorg.xrandr}/bin/xrandr --output \"$PRIMARY_DISPLAY\" --brightness 1";
        description = ''
          Command to run if activity resumes after this timer has activated but
          before the next timer. An empty string disables the canceller.
        '';
      };
    };
  };
in
{
  options.services.xserver.xidlehook = {
    enable = lib.mkEnableOption "xidlehook";

    timers = lib.mkOption {
      type = lib.types.listOf timerType;
      default = [ ];
      example = [
        {
          duration = 300;
          command = literalExpression ''"''${pkgs.slock}/bin/slock"'';
        }
        {
          duration = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      description = ''
        The duration is the number of seconds of inactivity which should trigger this timer.

        The command is what is invoked when the idle duration is reached. It's passed through \"/bin/sh -c\".

        The canceller is what is invoked when the user becomes active after the timer has gone off, but before the
        next timer (if any). Pass an empty string to not have one.
      '';
    };

    notWhenAudio = lib.mkEnableOption "Don't invoke the timer when any audio is playing";

    notWhenFullscreen = lib.mkEnableOption ''
      Don't invoke the timer when the current application is fullscreen.
      Useful for preventing a lockscreen when watching videos
    '';

    detectSleep = lib.mkEnableOption "Resetting the idle timer after the system resumes from suspend";

    once = lib.mkEnableOption "Exit after the whole chain of timer commands have been invoked once";

    socket = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "%t/xidlehook.socket";
      description = ''
        Listen to a unix socket at this address for events. Each event is one line of JSON data
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.timers != [ ];
        message = "services.xserver.xidlehook.timers must contain at least one timer.";
      }
    ];

    environment.systemPackages = [ pkgs.xidlehook ];

    systemd.user.services.xidlehook = {
      description = "xidlehook idle timer service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [ "${pkgs.xidlehook}/bin/xidlehook" ]
          ++ lib.optional cfg.notWhenAudio "--not-when-audio"
          ++ lib.optional cfg.notWhenFullscreen "--not-when-fullscreen"
          ++ lib.optional cfg.detectSleep "--detect-sleep"
          ++ lib.optional cfg.once "--once"
          ++ lib.optional (cfg.socket != null) "--socket"
          ++ lib.optional (cfg.socket != null) cfg.socket
          ++ lib.concatMap (timer: [
            "--timer"
            (toString timer.duration)
            timer.command
            timer.canceller
          ]) cfg.timers
        );
        Restart = "always";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.evanwporter ];
}
