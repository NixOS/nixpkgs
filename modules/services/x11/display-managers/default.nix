# This module declares the options to define a *display manager*, the
# program responsible for handling X logins (such as xdm, kdm, gdb, or
# SLiM).  The display manager allows the user to select a *session
# type*.  When the user logs in, the display manager starts the
# *session script* ("xsession" below) to launch the selected session
# type.  The session type defines two things: the *desktop manager*
# (e.g., KDE, Gnome or a plain xterm), and optionally the *window
# manager* (e.g. kwin or twm).

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xserver;
  xorg = pkgs.xorg;

  # file provided by services.xserver.displayManager.session.script
  xsession = wm: dm: pkgs.writeScript "xsession"
    ''
      #! /bin/sh
 
      exec > $HOME/.xsession-errors 2>&1

      source /etc/profile

      ### Load X defaults.
      if test -e ~/.Xdefaults; then
        ${xorg.xrdb}/bin/xrdb -merge ~/.Xdefaults
      fi

      ${optionalString cfg.startSSHAgent ''
        ### Start the SSH agent.
        export SSH_ASKPASS=${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass
        eval $(${pkgs.openssh}/bin/ssh-agent)
      ''}

      ### Allow user to override system-wide configuration
      if test -f ~/.xsession; then
          source ~/.xsession
      fi

      # The first argument of this script is the session type
      sessionType="$1"

      # The session type "<desktop-manager> + <window-manager>", so
      # extract those.
      windowManager="''${arg##* + }"
      : ''${windowManager:=${cfg.windowManager.default}}
      desktopManager="''${arg% + *}"
      : ''${desktopManager:=${cfg.desktopManager.default}}

      # Start the window manager.
      case $windowManager in
        ${concatMapStrings (s: ''
          (${s.name})
            ${s.start}
            ;;
        '') wm}
        (*) echo "$0: Window manager '$windowManager' not found.";;
      esac

      # Start the desktop manager.
      case $desktopManager in
        ${concatMapStrings (s: ''
          (${s.name})
            ${s.start}
            ;;
        '') dm}
        (*) echo "$0: Desktop manager '$desktopManager' not found.";;
      esac

      test -n "$waitPID" && wait "$waitPID"
      exit 0
    '';

  mkDesktops = names: pkgs.runCommand "desktops" {}
    ''
      ensureDir $out
      ${concatMapStrings (n: ''
        cat - > "$out/${n}.desktop" << EODESKTOP
        [Desktop Entry]
        Version=1.0
        Type=XSession
        TryExec=${cfg.displayManager.session.script}
        Exec=${cfg.displayManager.session.script} '${n}'
        Name=${n}
        Comment=
        EODESKTOP
      '') names}
    '';

in

{

  imports = [ ./kdm.nix ./slim.nix ];


  options = {

    services.xserver.displayManager = {

      xauthBin = mkOption {
        default = "${xorg.xauth}/bin/xauth";
        description = "Path to the <command>xauth</command> program used by display managers.";
      };

      xserverBin = mkOption {
        default = "${xorg.xorgserver}/bin/X";
        description = "Path to the X server used by display managers.";
      };

      xserverArgs = mkOption {
        default = [];
        example = [ "-ac" "-logverbose" "-nolisten tcp" ];
        description = "List of arguments for the X server.";
        apply = toString;
      };

      session = mkOption {
        default = [];
        example = [
          {
            manage = "desktop";
            name = "xterm";
            start = "
              ${pkgs.xterm}/bin/xterm -ls &
              waitPID=$!
            ";
          }
        ];
        description = ''
          List of sessions supported with the command used to start each
          session.  Each session script can set the
          <varname>waitPID</varname> shell variable to make this script
          wait until the end of the user session.  Each script is used
          to define either a windows manager or a desktop manager.  These
          can be differentiated by setting the attribute
          <varname>manage</varname> either to <literal>"window"</literal>
          or <literal>"desktop"</literal>.

          The list of desktop manager and window manager should appear
          inside the display manager with the desktop manager name
          followed by the window manager name.
        '';
        apply = list: rec {
          wm = filter (s: s.manage == "window") list;
          dm = filter (s: s.manage == "desktop") list;
          names = concatMap (d: map (w: d.name + " + " + w.name) wm) dm;
          desktops = mkDesktops names;
          script = xsession wm dm;
        };
      };

      job = mkOption {
        default = {};
        type = types.uniq types.optionSet;
        description = "This option defines how to start the display manager.";

        options = {
  
          preStart = mkOption {
            default = "";
            example = "rm -f /var/log/my-display-manager.log";
            description = "Script executed before the display manager is started.";
          };
         
          execCmd = mkOption {
            example = "${pkgs.slim}/bin/slim";
            description = "Command to start the display manager.";
          };
         
          environment = mkOption {
            default = {};
            example = { SLIM_CFGFILE = /etc/slim.conf; };
            description = "Additional environment variables needed by the display manager.";
          };
         
        };
        
      };

    };
    
  };

}
