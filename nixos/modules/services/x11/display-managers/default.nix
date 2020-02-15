# This module declares the options to define a *display manager*, the
# program responsible for handling X logins (such as LightDM, GDM, or SDDM).
# The display manager allows the user to select a *session
# type*. When the user logs in, the display manager starts the
# *session script* ("xsession" below) to launch the selected session
# type. The session type defines two things: the *desktop manager*
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

  # file provided by services.xserver.displayManager.sessionData.wrapper
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

      # Load X defaults. This should probably be safe on wayland too.
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
          eval exec ~/.xsession "$@"
      fi

      if test "$1"; then
          # Run the supplied session command. Remove any double quotes with eval.
          eval exec "$@"
      else
          # TODO: Do we need this? Should not the session always exist?
          echo "error: unknown session $1" 1>&2
          exit 1
      fi
    '';

  installedSessions = pkgs.runCommand "desktops"
    { # trivial derivation
      preferLocalBuild = true;
      allowSubstitutes = false;
    }
    ''
      mkdir -p "$out/share/"{xsessions,wayland-sessions}

      ${concatMapStrings (pkg: ''
        for n in ${concatStringsSep " " pkg.providedSessions}; do
          if ! test -f ${pkg}/share/wayland-sessions/$n.desktop -o \
                    -f ${pkg}/share/xsessions/$n.desktop; then
            echo "Couldn't find provided session name, $n.desktop, in session package ${pkg.name}:"
            echo "  ${pkg}"
            return 1
          fi
        done

        if test -d ${pkg}/share/xsessions; then
          ${xorg.lndir}/bin/lndir ${pkg}/share/xsessions $out/share/xsessions
        fi
        if test -d ${pkg}/share/wayland-sessions; then
          ${xorg.lndir}/bin/lndir ${pkg}/share/wayland-sessions $out/share/wayland-sessions
        fi
      '') cfg.displayManager.sessionPackages}
    '';

  dmDefault = cfg.desktopManager.default;
  # fallback default for cases when only default wm is set
  dmFallbackDefault = if dmDefault != null then dmDefault else "none";
  wmDefault = cfg.windowManager.default;

  defaultSessionFromLegacyOptions = dmFallbackDefault + optionalString (wmDefault != null && wmDefault != "none") "+${wmDefault}";

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

      setupCommands = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Shell commands executed just after the X server has started.

          This option is only effective for display managers for which this feature
          is supported; currently these are LightDM, GDM and SDDM.
        '';
      };

      sessionCommands = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            xmessage "Hello World!" &
          '';
        description = ''
          Shell commands executed just before the window or desktop manager is
          started. These commands are not currently sourced for Wayland sessions.
        '';
      };

      hiddenUsers = mkOption {
        type = types.listOf types.str;
        default = [ "nobody" ];
        description = ''
          A list of users which will not be shown in the display manager.
        '';
      };

      sessionPackages = mkOption {
        type = with types; listOf (package // {
          description = "package with provided sessions";
          check = p: assertMsg
            (package.check p && p ? providedSessions
            && p.providedSessions != [] && all isString p.providedSessions)
            ''
              Package, '${p.name}', did not specify any session names, as strings, in
              'passthru.providedSessions'. This is required when used as a session package.

              The session names can be looked up in:
                ${p}/share/xsessions
                ${p}/share/wayland-sessions
           '';
        });
        default = [];
        description = ''
          A list of packages containing x11 or wayland session files to be passed to the display manager.
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
          to define either a window manager or a desktop manager.  These
          can be differentiated by setting the attribute
          <varname>manage</varname> either to <literal>"window"</literal>
          or <literal>"desktop"</literal>.

          The list of desktop manager and window manager should appear
          inside the display manager with the desktop manager name
          followed by the window manager name.
        '';
      };

      sessionData = mkOption {
        description = "Data exported for display managers’ convenience";
        internal = true;
        default = {};
        apply = val: {
          wrapper = xsessionWrapper;
          desktops = installedSessions;
          sessionNames = concatMap (p: p.providedSessions) cfg.displayManager.sessionPackages;
          # We do not want to force users to set defaultSession when they have only single DE.
          autologinSession =
            if cfg.displayManager.defaultSession != null then
              cfg.displayManager.defaultSession
            else if cfg.displayManager.sessionData.sessionNames != [] then
              head cfg.displayManager.sessionData.sessionNames
            else
              null;
        };
      };

      defaultSession = mkOption {
        type = with types; nullOr str // {
          description = "session name";
          check = d:
            assertMsg (d != null -> (str.check d && elem d cfg.displayManager.sessionData.sessionNames)) ''
                Default graphical session, '${d}', not found.
                Valid names for 'services.xserver.displayManager.defaultSession' are:
                  ${concatStringsSep "\n  " cfg.displayManager.sessionData.sessionNames}
              '';
        };
        default =
          if dmDefault != null || wmDefault != null then
            defaultSessionFromLegacyOptions
          else
            null;
        example = "gnome";
        description = ''
          Graphical session to pre-select in the session chooser (only effective for GDM and LightDM).

          On GDM, LightDM and SDDM, it will also be used as a session for auto-login.
        '';
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
            "''${pkgs.lightdm}/bin/lightdm"
          '';
          description = "Command to start the display manager.";
        };

        environment = mkOption {
          type = types.attrsOf types.unspecified;
          default = {};
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
    assertions = [
      {
        assertion = cfg.desktopManager.default != null || cfg.windowManager.default != null -> cfg.displayManager.defaultSession == defaultSessionFromLegacyOptions;
        message = "You cannot use both services.xserver.displayManager.defaultSession option and legacy options (services.xserver.desktopManager.default and services.xserver.windowManager.default).";
      }
    ];

    warnings =
      mkIf (dmDefault != null || wmDefault != null) [
        ''
          The following options are deprecated:
            ${concatStringsSep "\n  " (map ({c, t}: t) (filter ({c, t}: c != null) [
            { c = dmDefault; t = "- services.xserver.desktopManager.default"; }
            { c = wmDefault; t = "- services.xserver.windowManager.default"; }
            ]))}
          Please use
            services.xserver.displayManager.defaultSession = "${defaultSessionFromLegacyOptions}";
          instead.
        ''
      ];

    services.xserver.displayManager.xserverBin = "${xorg.xorgserver.out}/bin/X";

    systemd.user.targets.graphical-session = {
      unitConfig = {
        RefuseManualStart = false;
        StopWhenUnneeded = false;
      };
    };

    # Create desktop files and scripts for starting sessions for WMs/DMs
    # that do not have upstream session files (those defined using services.{display,desktop,window}Manager.session options).
    services.xserver.displayManager.sessionPackages =
      let
        dms = filter (s: s.manage == "desktop") cfg.displayManager.session;
        wms = filter (s: s.manage == "window") cfg.displayManager.session;

        # Script responsible for starting the window manager and the desktop manager.
        xsession = dm: wm: pkgs.writeScript "xsession" ''
          #! ${pkgs.bash}/bin/bash

          # Legacy session script used to construct .desktop files from
          # `services.xserver.displayManager.session` entries. Called from
          # `sessionWrapper`.

          # Start the window manager.
          ${wm.start}

          # Start the desktop manager.
          ${dm.start}

          ${optionalString cfg.updateDbusEnvironment ''
            ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
          ''}

          test -n "$waitPID" && wait "$waitPID"

          ${config.systemd.package}/bin/systemctl --user stop graphical-session.target

          exit 0
        '';
      in
        # We will generate every possible pair of WM and DM.
        concatLists (
          crossLists
            (dm: wm: let
              sessionName = "${dm.name}${optionalString (wm.name != "none") ("+" + wm.name)}";
              script = xsession dm wm;
            in
              optional (dm.name != "none" || wm.name != "none")
                (pkgs.writeTextFile {
                  name = "${sessionName}-xsession";
                  destination = "/share/xsessions/${sessionName}.desktop";
                  # Desktop Entry Specification:
                  # - https://standards.freedesktop.org/desktop-entry-spec/latest/
                  # - https://standards.freedesktop.org/desktop-entry-spec/latest/ar01s06.html
                  text = ''
                    [Desktop Entry]
                    Version=1.0
                    Type=XSession
                    TryExec=${script}
                    Exec=${script}
                    Name=${sessionName}
                    DesktopNames=${sessionName}
                  '';
                } // {
                  providedSessions = [ sessionName ];
                })
            )
            [dms wms]
          );
  };

  imports = [
    (mkRemovedOptionModule [ "services" "xserver" "displayManager" "desktopManagerHandlesLidAndPower" ]
     "The option is no longer necessary because all display managers have already delegated lid management to systemd.")
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "job" "logsXsession" ] [ "services" "xserver" "displayManager" "job" "logToFile" ])
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "logToJournal" ] [ "services" "xserver" "displayManager" "job" "logToJournal" ])
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "extraSessionFilesPackages" ] [ "services" "xserver" "displayManager" "sessionPackages" ])
  ];

}
