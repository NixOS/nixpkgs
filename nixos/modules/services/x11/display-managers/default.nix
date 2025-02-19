# This module declares the options to define a *display manager*, the
# program responsible for handling X logins (such as LightDM, GDM, or SDDM).
# The display manager allows the user to select a *session
# type*. When the user logs in, the display manager starts the
# *session script* ("xsession" below) to launch the selected session
# type. The session type defines two things: the *desktop manager*
# (e.g., KDE, Gnome or a plain xterm), and optionally the *window
# manager* (e.g. kwin or twm).

{ config, lib, options, pkgs, ... }:

let
  inherit (lib) mkOption types literalExpression optionalString;

  cfg = config.services.xserver;
  xorg = pkgs.xorg;

  fontconfig = config.fonts.fontconfig;
  xresourcesXft = pkgs.writeText "Xresources-Xft" ''
    Xft.antialias: ${if fontconfig.antialias then "1" else "0"}
    Xft.rgba: ${fontconfig.subpixel.rgba}
    Xft.lcdfilter: lcd${fontconfig.subpixel.lcdfilter}
    Xft.hinting: ${if fontconfig.hinting.enable then "1" else "0"}
    Xft.autohint: ${if fontconfig.hinting.autohint then "1" else "0"}
    Xft.hintstyle: ${fontconfig.hinting.style}
  '';

  # FIXME: this is an ugly hack.
  # Some sessions (read: most WMs) don't activate systemd's `graphical-session.target`.
  # Other sessions (read: most non-WMs) expect `graphical-session.target` to be reached
  # when the entire session is actually ready. We used to just unconditionally force
  # `graphical-session.target` to be activated in the session wrapper so things like
  # xdg-autostart-generator work on sessions that are wrong, but this broke sessions
  # that do things right. So, preserve this behavior (with some extra steps) by matching
  # on XDG_CURRENT_DESKTOP and deliberately ignoring sessions we know can do the right thing.
  fakeSession = action: ''
      session_is_systemd_aware=$(
        IFS=:
        for i in $XDG_CURRENT_DESKTOP; do
          case $i in
            KDE|GNOME|Pantheon|X-NIXOS-SYSTEMD-AWARE) echo "1"; exit; ;;
            *) ;;
          esac
        done
      )

      if [ -z "$session_is_systemd_aware" ]; then
        /run/current-system/systemd/bin/systemctl --user ${action} nixos-fake-graphical-session.target
      fi
  '';

  # file provided by services.xserver.displayManager.sessionData.wrapper
  xsessionWrapper = pkgs.writeScript "xsession-wrapper"
    ''
      #! ${pkgs.bash}/bin/bash

      # Shared environment setup for graphical sessions.

      . /etc/profile
      if test -f ~/.profile; then
          source ~/.profile
      fi

      cd "$HOME"

      # Allow the user to execute commands at the beginning of the X session.
      if test -f ~/.xprofile; then
          source ~/.xprofile
      fi

      ${optionalString config.services.displayManager.logToJournal ''
        if [ -z "$_DID_SYSTEMD_CAT" ]; then
          export _DID_SYSTEMD_CAT=1
          exec ${config.systemd.package}/bin/systemd-cat -t xsession "$0" "$@"
        fi
      ''}

      ${optionalString config.services.displayManager.logToFile ''
        exec &> >(tee ~/.xsession-errors)
      ''}

      # Load X defaults. This should probably be safe on wayland too.
      ${xorg.xrdb}/bin/xrdb -merge ${xresourcesXft}
      if test -e ~/.Xresources; then
          ${xorg.xrdb}/bin/xrdb -merge ~/.Xresources
      elif test -e ~/.Xdefaults; then
          ${xorg.xrdb}/bin/xrdb -merge ~/.Xdefaults
      fi

      # Import environment variables into the systemd user environment.
      ${optionalString (cfg.displayManager.importedVariables != []) (
        "/run/current-system/systemd/bin/systemctl --user import-environment "
          + toString (lib.unique cfg.displayManager.importedVariables)
      )}

      # Speed up application start by 50-150ms according to
      # https://kdemonkey.blogspot.com/2008/04/magic-trick.html
      compose_cache="''${XCOMPOSECACHE:-$HOME/.compose-cache}"
      mkdir -p "$compose_cache"
      # To avoid accidentally deleting a wrongly set up XCOMPOSECACHE directory,
      # defensively try to delete cache *files* only, following the file format specified in
      # https://gitlab.freedesktop.org/xorg/lib/libx11/-/blob/master/modules/im/ximcp/imLcIm.c#L353-358
      # sprintf (*res, "%s/%c%d_%03x_%08x_%08x", dir, _XimGetMyEndian(), XIM_CACHE_VERSION, (unsigned int)sizeof (DefTree), hash, hash2);
      ${pkgs.findutils}/bin/find "$compose_cache" -maxdepth 1 -regextype posix-extended -regex '.*/[Bl][0-9]+_[0-9a-f]{3}_[0-9a-f]{8}_[0-9a-f]{8}' -delete
      unset compose_cache

      # Work around KDE errors when a user first logs in and
      # .local/share doesn't exist yet.
      mkdir -p "''${XDG_DATA_HOME:-$HOME/.local/share}"

      unset _DID_SYSTEMD_CAT

      ${cfg.displayManager.sessionCommands}

      ${fakeSession "start"}

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
in

{
  options = {

    services.xserver.displayManager = {

      xauthBin = mkOption {
        internal = true;
        default = "${xorg.xauth}/bin/xauth";
        defaultText = literalExpression ''"''${pkgs.xorg.xauth}/bin/xauth"'';
        description = "Path to the {command}`xauth` program used by display managers.";
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

      session = mkOption {
        default = [];
        type = types.listOf types.attrs;
        example = literalExpression
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
          {var}`waitPID` shell variable to make this script
          wait until the end of the user session.  Each script is used
          to define either a window manager or a desktop manager.  These
          can be differentiated by setting the attribute
          {var}`manage` either to `"window"`
          or `"desktop"`.

          The list of desktop manager and window manager should appear
          inside the display manager with the desktop manager name
          followed by the window manager name.
        '';
      };

      importedVariables = mkOption {
        type = types.listOf (types.strMatching "[a-zA-Z_][a-zA-Z0-9_]*");
        visible = false;
        description = ''
          Environment variables to import into the systemd user environment.
        '';
      };

    };

  };

  config = {
    services.displayManager.sessionData.wrapper = xsessionWrapper;

    services.xserver.displayManager.xserverBin = "${xorg.xorgserver.out}/bin/X";

    services.xserver.displayManager.importedVariables = [
      # This is required by user units using the session bus.
      "DBUS_SESSION_BUS_ADDRESS"
      # These are needed by the ssh-agent unit.
      "DISPLAY"
      "XAUTHORITY"
      # This is required to specify session within user units (e.g. loginctl lock-session).
      "XDG_SESSION_ID"
    ];

    systemd.user.targets.nixos-fake-graphical-session = {
      unitConfig = {
        Description = "Fake graphical-session target for non-systemd-aware sessions";
        BindsTo = "graphical-session.target";
      };
    };

    # Create desktop files and scripts for starting sessions for WMs/DMs
    # that do not have upstream session files (those defined using services.{display,desktop,window}Manager.session options).
    services.displayManager.sessionPackages =
      let
        dms = lib.filter (s: s.manage == "desktop") cfg.displayManager.session;
        wms = lib.filter (s: s.manage == "window") cfg.displayManager.session;

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

          ${fakeSession "stop"}

          exit 0
        '';
      in
        # We will generate every possible pair of WM and DM.
        lib.concatLists (
            lib.mapCartesianProduct
            ({dm, wm}: let
              sessionName = "${dm.name}${optionalString (wm.name != "none") ("+" + wm.name)}";
              prettyName =
                if dm.name != "none" then
                  "${dm.prettyName or dm.name}${optionalString (wm.name != "none") (" (" + (wm.prettyName or wm.name) + ")")}"
                else
                  (wm.prettyName or wm.name);
              script = xsession dm wm;
              desktopNames = if dm ? desktopNames
                             then lib.concatStringsSep ";" dm.desktopNames
                             else sessionName;
            in
              lib.optional (dm.name != "none" || wm.name != "none")
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
                    Name=${prettyName}
                    DesktopNames=${desktopNames}
                  '';
                } // {
                  providedSessions = [ sessionName ];
                })
            )
            { dm = dms; wm = wms; }
          );
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "xserver" "displayManager" "desktopManagerHandlesLidAndPower" ]
     "The option is no longer necessary because all display managers have already delegated lid management to systemd.")
    (lib.mkRenamedOptionModule [ "services" "xserver" "displayManager" "job" "logsXsession" ] [ "services" "displayManager" "logToFile" ])
    (lib.mkRenamedOptionModule [ "services" "xserver" "displayManager" "logToJournal" ] [ "services" "displayManager" "logToJournal" ])
    (lib.mkRenamedOptionModule [ "services" "xserver" "displayManager" "extraSessionFilesPackages" ] [ "services" "displayManager" "sessionPackages" ])
  ];

}
