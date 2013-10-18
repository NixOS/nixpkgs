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
      exec ${pkgs.xorg.xorgserver}/bin/Xvfb "$@" -xkbdir "${pkgs.xkeyboard_config}/etc/X11/xkb"
    '';

  # ‘xinetd’ is insanely braindamaged in that it sends stderr to
  # stdout.  Thus requires just about any xinetd program to be
  # wrapped to redirect its stderr.  Sigh.
  x11vncWrapper = pkgs.writeScriptBin "x11vnc-wrapper"
    ''
      #! ${pkgs.stdenv.shell}
      export PATH=${makeSearchPath "bin" [ xvfbWrapper pkgs.gawk pkgs.which pkgs.openssl pkgs.xorg.xauth pkgs.nettools pkgs.shadow pkgs.procps pkgs.utillinux pkgs.bash ]}:$PATH
      export FD_GEOM=1024x786x24
      exec ${pkgs.x11vnc}/bin/x11vnc -inetd -display WAIT:1024x786:cmd=FINDCREATEDISPLAY-Xvfb.xdmcp -unixpw -ssl SAVE 2> /var/log/x11vnc.log
    '';

in 

{

  config = {
  
    services.xserver.enable = true;

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

    services.xinetd.enable = true;
    services.xinetd.services = singleton
      { name = "x11vnc";
        port = 5900;
        unlisted = true;
        user = "root";
        server = "${x11vncWrapper}/bin/x11vnc-wrapper";
      };

  };

}
