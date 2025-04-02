{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.xserver.displayManager.startx;

  # WM session script
  # Note: this assumes a single WM has been enabled
  sessionScript = lib.concatMapStringsSep "\n" (
    i: i.start
  ) config.services.xserver.windowManager.session;

in

{

  ###### interface

  options = {
    services.xserver.displayManager.startx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable the dummy "startx" pseudo-display manager, which
          allows users to start X manually via the `startx` command from a
          virtual terminal.

          ::: {.note}
          The X server will run under the current user, not as root.
          :::
        '';
      };

      generateScript = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to generate the system-wide xinitrc script (/etc/X11/xinit/xinitrc).
          This script will take care of setting up the session for systemd user
          services, running the window manager and cleaning up on exit.

          ::: {.note}
          This script will only be used by `startx` when both `.xinitrc` does not
          exists and the `XINITRC` environment variable is unset.
          :::
        '';
      };

      extraCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Shell commands to be added to the system-wide xinitrc script.
        '';
      };

    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    services.xserver.exportConfiguration = true;

    # Other displayManagers log to /dev/null because they're services and put
    # Xorg's stdout in the journal
    #
    # To send log to Xorg's default log location ($XDG_DATA_HOME/xorg/), we do
    # not specify a log file when running X
    services.xserver.logFile = lib.mkDefault null;

    # Implement xserverArgs via xinit's system-wide xserverrc
    environment.etc."X11/xinit/xserverrc".source = pkgs.writeShellScript "xserverrc" ''
      exec ${pkgs.xorg.xorgserver}/bin/X \
        ${toString config.services.xserver.displayManager.xserverArgs} "$@"
    '';

    # Add a sane system-wide xinitrc script
    environment.etc."X11/xinit/xinitrc" = lib.mkIf cfg.generateScript {
      source = pkgs.writeShellScript "xinitrc" ''
        ${cfg.extraCommands}

        # start user services
        systemctl --user import-environment DISPLAY XDG_SESSION_ID
        systemctl --user start nixos-fake-graphical-session.target

        # run the window manager script
        ${sessionScript}
        wait $waitPID

        # stop services and all subprocesses
        systemctl --user stop nixos-fake-graphical-session.target
        kill 0
      '';
    };

    environment.systemPackages = with pkgs; [ xorg.xinit ];

  };

}
