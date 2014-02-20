# This module implements a terminal service based on ‘x11vnc’.  It
# listens on port 5900 for VNC connections.  It then presents a login
# screen to the user.  If the user successfully authenticates, x11vnc
# checks to see if a X server is already running for that user.  If
# not, a X server (Xvfb) is started for that user.  The Xvfb instances
# persist across VNC sessions.

{ config, pkgs, ... }:

with pkgs.lib;

let

  # Wrap Xvfb to set some flags/variables.
  xvfbWrapper = pkgs.writeScriptBin "Xvfb"
    ''
      #! ${pkgs.stdenv.shell}
      export XKB_BINDIR=${pkgs.xorg.xkbcomp}/bin
      export XORG_DRI_DRIVER_PATH=${pkgs.mesa}/lib/dri
      exec ${pkgs.xorg.xorgserver}/bin/Xvfb "$@" -xkbdir ${pkgs.xkeyboard_config}/etc/X11/xkb
    '';

in

{

  config = {

    services.xserver.enable = true;
    hardware.opengl.videoDrivers = [];

    # Enable KDM.  Any display manager will do as long as it supports XDMCP.
    services.xserver.displayManager.kdm.enable = true;
    services.xserver.displayManager.kdm.enableXDMCP = true;
    services.xserver.displayManager.kdm.extraConfig =
      ''
        [General]
        # We're headless, so don't bother starting an X server.
        StaticServers=

        [Xdmcp]
        Xaccess=${pkgs.writeText "Xaccess" "localhost"}
      '';

    systemd.sockets.terminal-server =
      { description = "Terminal Server Socket";
        wantedBy = [ "sockets.target" ];
        before = [ "multi-user.target" ];
        socketConfig.Accept = true;
        socketConfig.ListenStream = 5900;
      };

    systemd.services."terminal-server@" =
      { description = "Terminal Server";

        path =
          [ xvfbWrapper pkgs.gawk pkgs.which pkgs.openssl pkgs.xorg.xauth
            pkgs.nettools pkgs.shadow pkgs.procps pkgs.utillinux pkgs.bash
          ];

        environment.FD_GEOM = "1024x786x24";
        environment.FD_XDMCP_IF = "127.0.0.1";
        #environment.FIND_DISPLAY_OUTPUT = "/tmp/foo"; # to debug the "find display" script

        serviceConfig =
          { StandardInput = "socket";
            StandardOutput = "socket";
            StandardError = "journal";
            ExecStart = "@${pkgs.x11vnc}/bin/x11vnc x11vnc -inetd -display WAIT:1024x786:cmd=FINDCREATEDISPLAY-Xvfb.xdmcp -unixpw -ssl SAVE";
            # Don't kill the X server when the user quits the VNC
            # connection.  FIXME: the X server should run in a
            # separate systemd session.
            KillMode = "process";
          };
      };

  };

}
