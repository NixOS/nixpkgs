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

  vaapiDrivers = pkgs.buildEnv {
    name = "vaapi-drivers";
    paths = cfg.vaapiDrivers;
    # We only want /lib/dri, but with a single input path, we need "/" for it to work
    pathsToLink = [ "/" ];
  };

  # file provided by services.xserver.displayManager.session.script
  xsession = wm: dm: pkgs.writeScript "xsession"
    ''
      #! /bin/sh

      . /etc/profile
      cd "$HOME"

      # The first argument of this script is the session type.
      sessionType="$1"
      if [ "$sessionType" = default ]; then sessionType=""; fi

      ${optionalString (!cfg.displayManager.job.logsXsession) ''
        exec > ~/.xsession-errors 2>&1
      ''}

      ${optionalString cfg.displayManager.desktopManagerHandlesLidAndPower ''
        # Stop systemd from handling the power button and lid switch,
        # since presumably the desktop environment will handle these.
        if [ -z "$_INHIBITION_LOCK_TAKEN" ]; then
          export _INHIBITION_LOCK_TAKEN=1
          exec ${config.systemd.package}/bin/systemd-inhibit --what=handle-lid-switch:handle-power-key "$0" "$sessionType"
        fi

      ''}

      ${optionalString cfg.startOpenSSHAgent ''
        if test -z "$SSH_AUTH_SOCK"; then
            # Restart this script as a child of the SSH agent.  (It is
            # also possible to start the agent as a child that prints
            # the required environment variabled on stdout, but in
            # that mode ssh-agent is not terminated when we log out.)
            export SSH_ASKPASS=${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass
            exec ${pkgs.openssh}/bin/ssh-agent "$0" "$sessionType"
        fi
      ''}

      ${optionalString cfg.startGnuPGAgent ''
        if test -z "$SSH_AUTH_SOCK"; then
            # Restart this script as a child of the GnuPG agent.
            exec "${pkgs.gnupg}/bin/gpg-agent"                         \
              --enable-ssh-support --daemon                             \
              --pinentry-program "${pkgs.pinentry}/bin/pinentry-gtk-2"  \
              --write-env-file "$HOME/.gpg-agent-info"                  \
              "$0" "$sessionType"
        fi
      ''}

      # Handle being called by kdm.
      if test "''${1:0:1}" = /; then eval exec "$1"; fi

      # Start PulseAudio if enabled.
      ${optionalString (config.hardware.pulseaudio.enable) ''
        ${optionalString (!config.hardware.pulseaudio.systemWide)
          "${pkgs.pulseaudio}/bin/pulseaudio --start"
        }

        # Publish access credentials in the root window.
        ${pkgs.pulseaudio}/bin/pactl load-module module-x11-publish "display=$DISPLAY"

        # Keep track of devices.  Mostly useful for Phonon/KDE.
        ${pkgs.pulseaudio}/bin/pactl load-module module-device-manager "do_routing=1"
      ''}

      # Load X defaults.
      if test -e ~/.Xdefaults; then
          ${xorg.xrdb}/bin/xrdb -merge ~/.Xdefaults
      fi

      export LIBVA_DRIVERS_PATH=${vaapiDrivers}/lib/dri

      # Speed up application start by 50-150ms according to
      # http://kdemonkey.blogspot.nl/2008/04/magic-trick.html
      rm -rf $HOME/.compose-cache
      mkdir $HOME/.compose-cache

      ${cfg.displayManager.sessionCommands}

      # Allow the user to setup a custom session type.
      if test -x ~/.xsession; then
          exec ~/.xsession
      else
          if test "$sessionType" = "custom"; then
              sessionType="" # fall-thru if there is no ~/.xsession
          fi
      fi

      # The session type is "<desktop-manager> + <window-manager>", so
      # extract those.
      windowManager="''${sessionType##* + }"
      : ''${windowManager:=${cfg.windowManager.default}}
      desktopManager="''${sessionType% + *}"
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
      mkdir -p $out
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

  options = {

    services.xserver.displayManager = {

      xauthBin = mkOption {
        internal = true;
        default = "${xorg.xauth}/bin/xauth";
        description = "Path to the <command>xauth</command> program used by display managers.";
      };

      xserverBin = mkOption {
        type = types.path;
        default = "${xorg.xorgserver}/bin/X";
        description = "Path to the X server used by display managers.";
      };

      xserverArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-ac" "-logverbose" "-nolisten tcp" ];
        description = "List of arguments for the X server.";
        apply = toString;
      };

      sessionCommands = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            xmessage "Hello World!" &
          '';
        description = "Shell commands executed just before the window or desktop manager is started.";
      };

      desktopManagerHandlesLidAndPower = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether the display manager should prevent systemd from handling
          lid and power events. This is normally handled by the desktop
          environment's power manager. Turn this off when using a minimal
          X11 setup without a full power manager.
        '';
      };

      session = mkOption {
        default = [];
        example = literalExample
          ''
            [ { manage = "desktop";
                name = "xterm";
                start = '''
                  ''${pkgs.xterm}/bin/xterm -ls &
                  waitPID=$!
                ''';
              }
            ]
          '';
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
          names = flip concatMap dm
            (d: map (w: d.name + optionalString (w.name != "none") (" + " + w.name))
              (filter (w: d.name != "none" || w.name != "none") wm));
          desktops = mkDesktops names;
          script = xsession wm dm;
        };
      };

      job = {

        preStart = mkOption {
          type = types.lines;
          default = "";
          example = "rm -f /var/log/my-display-manager.log";
          description = "Script executed before the display manager is started.";
        };

        execCmd = mkOption {
          type = types.str;
          example = "${pkgs.slim}/bin/slim";
          description = "Command to start the display manager.";
        };

        environment = mkOption {
          type = types.attrsOf types.unspecified;
          default = {};
          example = { SLIM_CFGFILE = /etc/slim.conf; };
          description = "Additional environment variables needed by the display manager.";
        };

        logsXsession = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether the display manager redirects the
            output of the session script to
            <filename>~/.xsession-errors</filename>.
          '';
        };

      };

    };

  };

}
