# This module declares the options to define a *display manager*, the
# program responsible for handling X logins (such as xdm, gdb, or
# SLiM).  The display manager allows the user to select a *session
# type*.  When the user logs in, the display manager starts the
# *session script* ("xsession" below) to launch the selected session
# type.  The session type defines two things: the *desktop manager*
# (e.g., KDE, Gnome or a plain xterm), and optionally the *window
# manager* (e.g. kwin or twm).

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver;
  xorg = pkgs.xorg;

  fontconfig = config.fonts.fontconfig;
  xresourcesXft = pkgs.writeText "Xresources-Xft" ''
    ${optionalString (fontconfig.dpi != 0) ''Xft.dpi: ${toString fontconfig.dpi}''}
    Xft.antialias: ${if fontconfig.antialias then "1" else "0"}
    Xft.rgba: ${fontconfig.subpixel.rgba}
    Xft.lcdfilter: lcd${fontconfig.subpixel.lcdfilter}
    Xft.hinting: ${if fontconfig.hinting.enable then "1" else "0"}
    Xft.autohint: ${if fontconfig.hinting.autohint then "1" else "0"}
    Xft.hintstyle: hintslight
  '';

  # file provided by services.xserver.displayManager.session.wrapper
  xsessionWrapper = pkgs.writeScript "xsession-wrapper"
    ''
      #! ${pkgs.bash}/bin/bash

      # Shared environment setup for graphical sessions.

      . /etc/profile
      cd "$HOME"

      ${optionalString cfg.startDbusSession ''
        if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
          exec ${pkgs.dbus.dbus-launch} --exit-with-session "$0" "$@"
        fi
      ''}

      ${optionalString cfg.displayManager.job.logToJournal ''
        if [ -z "$_DID_SYSTEMD_CAT" ]; then
          export _DID_SYSTEMD_CAT=1
          exec ${config.systemd.package}/bin/systemd-cat -t xsession "$0" "$@"
        fi
      ''}

      ${optionalString cfg.displayManager.job.logToFile ''
        exec &> >(tee ~/.xsession-errors)
      ''}

      # Start PulseAudio if enabled.
      ${optionalString (config.hardware.pulseaudio.enable) ''
        # Publish access credentials in the root window.
        if ${config.hardware.pulseaudio.package.out}/bin/pulseaudio --dump-modules | grep module-x11-publish &> /dev/null; then
          ${config.hardware.pulseaudio.package.out}/bin/pactl load-module module-x11-publish "display=$DISPLAY"
        fi
      ''}

      # Tell systemd about our $DISPLAY and $XAUTHORITY.
      # This is needed by the ssh-agent unit.
      #
      # Also tell systemd about the dbus session bus address.
      # This is required by user units using the session bus.
      ${config.systemd.package}/bin/systemctl --user import-environment DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS

      # Load X defaults.
      # FIXME: Check XDG_SESSION_TYPE against x11
      ${xorg.xrdb}/bin/xrdb -merge ${xresourcesXft}
      if test -e ~/.Xresources; then
          ${xorg.xrdb}/bin/xrdb -merge ~/.Xresources
      elif test -e ~/.Xdefaults; then
          ${xorg.xrdb}/bin/xrdb -merge ~/.Xdefaults
      fi

      # Speed up application start by 50-150ms according to
      # http://kdemonkey.blogspot.nl/2008/04/magic-trick.html
      rm -rf "$HOME/.compose-cache"
      mkdir "$HOME/.compose-cache"

      # Work around KDE errors when a user first logs in and
      # .local/share doesn't exist yet.
      mkdir -p "$HOME/.local/share"

      unset _DID_SYSTEMD_CAT

      ${cfg.displayManager.sessionCommands}

      # Allow the user to execute commands at the beginning of the X session.
      if test -f ~/.xprofile; then
          source ~/.xprofile
      fi

      # Start systemd user services for graphical sessions
      ${config.systemd.package}/bin/systemctl --user start graphical-session.target

      # Allow the user to setup a custom session type.
      if test -x ~/.xsession; then
          exec ~/.xsession
      fi

      if test "$1"; then
          # Run the supplied session command. Remove any double quotes with eval.
          eval exec "$@"
      else
          # Fall back to the default window/desktopManager
          exec ${cfg.displayManager.session.script}
      fi
    '';

  # file provided by services.xserver.displayManager.session.script
  xsession = wm: dm: pkgs.writeScript "xsession"
    ''
      #! ${pkgs.bash}/bin/bash

      # Legacy session script used to construct .desktop files from
      # `services.xserver.displayManager.session` entries. Called from
      # `sessionWrapper`.

      # Expected parameters:
      #   $1 = <desktop-manager>+<window-manager>

      # The first argument of this script is the session type.
      sessionType="$1"
      if [ "$sessionType" = default ]; then sessionType=""; fi

      # The session type is "<desktop-manager>+<window-manager>", so
      # extract those (see:
      # http://wiki.bash-hackers.org/syntax/pe#substring_removal).
      windowManager="''${sessionType##*+}"
      : ''${windowManager:=${cfg.windowManager.default}}
      desktopManager="''${sessionType%%+*}"
      : ''${desktopManager:=${cfg.desktopManager.default}}

      # Start the window manager.
      case "$windowManager" in
        ${concatMapStrings (s: ''
          (${s.name})
            ${s.start}
            ;;
        '') wm}
        (*) echo "$0: Window manager '$windowManager' not found.";;
      esac

      # Start the desktop manager.
      case "$desktopManager" in
        ${concatMapStrings (s: ''
          (${s.name})
            ${s.start}
            ;;
        '') dm}
        (*) echo "$0: Desktop manager '$desktopManager' not found.";;
      esac

      ${optionalString cfg.updateDbusEnvironment ''
        ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
      ''}

      test -n "$waitPID" && wait "$waitPID"

      ${config.systemd.package}/bin/systemctl --user stop graphical-session.target

      exit 0
    '';

  # Desktop Entry Specification:
  # - https://standards.freedesktop.org/desktop-entry-spec/latest/
  # - https://standards.freedesktop.org/desktop-entry-spec/latest/ar01s06.html
  mkDesktops = names: pkgs.runCommand "desktops"
    { # trivial derivation
      preferLocalBuild = true;
      allowSubstitutes = false;
    }
    ''
      mkdir -p "$out/share/xsessions"
      ${concatMapStrings (n: ''
        cat - > "$out/share/xsessions/${n}.desktop" << EODESKTOP
        [Desktop Entry]
        Version=1.0
        Type=XSession
        TryExec=${cfg.displayManager.session.script}
        Exec=${cfg.displayManager.session.script} "${n}"
        Name=${n}
        Comment=
        EODESKTOP
      '') names}

      ${concatMapStrings (pkg: ''
        ${xorg.lndir}/bin/lndir ${pkg}/share/xsessions $out/share/xsessions
      '') cfg.displayManager.extraSessionFilePackages}
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
        description = "Path to the X server used by display managers.";
      };

      xserverArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-ac" "-logverbose" "-verbose" "-nolisten tcp" ];
        description = "List of arguments for the X server.";
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

      hiddenUsers = mkOption {
        type = types.listOf types.str;
        default = [ "nobody" ];
        description = ''
          A list of users which will not be shown in the display manager.
        '';
      };

      extraSessionFilePackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          A list of packages containing xsession files to be passed to the display manager.
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
            (d: map (w: d.name + optionalString (w.name != "none") ("+" + w.name))
              (filter (w: d.name != "none" || w.name != "none") wm));
          desktops = mkDesktops names;
          script = xsession wm dm;
          wrapper = xsessionWrapper;
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
          example = literalExample ''
            "''${pkgs.slim}/bin/slim"
          '';
          description = "Command to start the display manager.";
        };

        environment = mkOption {
          type = types.attrsOf types.unspecified;
          default = {};
          example = { SLIM_CFGFILE = "/etc/slim.conf"; };
          description = "Additional environment variables needed by the display manager.";
        };

        logToFile = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether the display manager redirects the output of the
            session script to <filename>~/.xsession-errors</filename>.
          '';
        };

        logToJournal = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether the display manager redirects the output of the
            session script to the systemd journal.
          '';
        };

      };

    };

  };

  config = {
    services.xserver.displayManager.xserverBin = "${xorg.xorgserver.out}/bin/X";

    systemd.user.targets.graphical-session = {
      unitConfig = {
        RefuseManualStart = false;
        StopWhenUnneeded = false;
      };
    };
  };

  imports = [
   (mkRemovedOptionModule [ "services" "xserver" "displayManager" "desktopManagerHandlesLidAndPower" ]
     "The option is no longer necessary because all display managers have already delegated lid management to systemd.")
  ];

}
