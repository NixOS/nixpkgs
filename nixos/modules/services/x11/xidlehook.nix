{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.xidlehook;
in
  {
    options = {
      services.xserver.xidlehook = {
        enable = mkEnableOption "xidlehook";

        notWhenFullscreen = mkOption {
          default = true;
          description = "Whether to lock the screen when an application is fullscreened.";
          type = types.bool;
        };

        notWhenAudio = mkOption {
          default = false;
          description = "Whether to lock the screen when audio is playing.";
          type = types.bool;
        };

        socket = mkOption {
          default = ".local/xidlehook.socket";
          description = ''
            Socket file for controlling the daemon. The path is relative to the
            user's home directory. Set to null to not have one.
          '';
          type = types.nullOr types.str;
        };

        timerPkgs = mkOption {
          default = with pkgs; [xorg.xrandr gawk i3lock-fancy-rapid];
          description = "Packages added to PATH for the timer commands.";
        };

        timers = mkOption {
          default = let brightnessCmd = tgt:
            "xrandr --output $(xrandr | awk '/ connected/{print $1}') --brightness ${toString tgt} ; " +
            "echo brightness ${toString tgt}"; in
          [
            {
              seconds = 5*60-5;
              command = brightnessCmd 0.5;
              canceller = brightnessCmd 1;
            }
            {
              seconds = 5;
              command = brightnessCmd 1 + " ; i3lock-fancy-rapid 10 5";
            }
          ];
          description = ''
            List of commands to run after the screen has been idle for a given \
            amount of time. N.B. times are cumulative here - in the example \
            below the first command runs after the screen is idle for 60 \
            seconds and the second command runs after the screen has been idle \
            for 70 seconds.
          '';

          type = with types; listOf (
            submodule {
              options = {
                seconds = mkOption {
                  type = ints.unsigned;
                  description = ''
                    How long to wait while the screen is idle before running \
                    the command.
                  '';
                };

                command = mkOption {
                  type = str;
                  description = "Command to run. Passed through sh -c.";
                };

                canceller = mkOption {
                  type = str;
                  description = ''
                    The canceller is what is invoked when the user becomes \
                    active after the timer has gone off, but before the next \
                    timer (if any). Pass an empty string to not have one.
                  '';
                  default = "";
                };
              };
            }
          );

          example = [
            { seconds = 60;
              command = "${pkgs.libnotify}/bin/notify-send \"Locking soon\"";
            }
            { seconds = 10;
              command = "{pkgs.i3lock}/bin/i3lock";
            }
          ];
        };


        extraOptions = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            Additional command-line arguments to pass to
            <command>xidlehook</command>.
          '';
        };
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ xidlehook ];
      systemd.user.services.xidlehook = with lib;
        let socketEscaped = "\${HOME}/" + strings.escapeShellArg cfg.socket; in {
        description = "xidlehook service";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        path = cfg.timerPkgs;
        preStart = optionalString (!(isNull cfg.socket))
          "mkdir -p $(dirname ${socketEscaped}) ; rm -f ${socketEscaped}";
        serviceConfig = {
          ExecStart = strings.concatStringsSep " " ([
            "${pkgs.xidlehook}/bin/xidlehook"
          ] ++ optional cfg.notWhenFullscreen
            "--not-when-fullscreen"
          ++ optional cfg.notWhenAudio
            "--not-when-audio"
          ++ [(strings.escapeShellArgs (lists.concatMap (timer:
            ["--timer" (toString timer.seconds) timer.command timer.canceller])
            cfg.timers))]
          ++ optional (!(isNull cfg.socket)) "--socket ${socketEscaped}"
          ++ cfg.extraOptions);
          Restart = "always";
        };
      };
      assertions = [
        {
          assertion = lib.lists.length cfg.timers != 0;
          message = "You must specify at least one timer for xidlehook.";
        }
      ];
    };
  }
