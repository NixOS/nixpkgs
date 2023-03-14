# This module declares the options to define a *display manager*, the
# program responsible for handling X logins (such as LightDM, GDM, or SDDM).
# The display manager allows the user to select a *session
# type*. When the user logs in, the display manager starts the
# *session script* ("xsession" below) to launch the selected session
# type. The session type defines two things: the *desktop manager*
# (e.g., KDE, Gnome or a plain xterm), and optionally the *window
# manager* (e.g. kwin or twm).

{ config, lib, options, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver;
  opt = options.services.xserver;
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

      ${optionalString cfg.displayManager.job.logToJournal ''
        if [ -z "$_DID_SYSTEMD_CAT" ]; then
          export _DID_SYSTEMD_CAT=1
          exec ${config.systemd.package}/bin/systemd-cat -t xsession "$0" "$@"
        fi
      ''}

      ${optionalString cfg.displayManager.job.logToFile ''
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
          + toString (unique cfg.displayManager.importedVariables)
      )}

      # Speed up application start by 50-150ms according to
      # http://kdemonkey.blogspot.nl/2008/04/magic-trick.html
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

      # Start systemd user services for graphical sessions
      /run/current-system/systemd/bin/systemctl --user start graphical-session.target

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
          ${pkgs.buildPackages.xorg.lndir}/bin/lndir ${pkg}/share/xsessions $out/share/xsessions
        fi
        if test -d ${pkg}/share/wayland-sessions; then
          ${pkgs.buildPackages.xorg.lndir}/bin/lndir ${pkg}/share/wayland-sessions $out/share/wayland-sessions
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
        defaultText = literalExpression ''"''${pkgs.xorg.xauth}/bin/xauth"'';
        description = lib.mdDoc "Path to the {command}`xauth` program used by display managers.";
      };

      xserverBin = mkOption {
        type = types.path;
        description = lib.mdDoc "Path to the X server used by display managers.";
      };

      xserverArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-ac" "-logverbose" "-verbose" "-nolisten tcp" ];
        description = lib.mdDoc "List of arguments for the X server.";
      };

      setupCommands = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Shell commands executed just before the window or desktop manager is
          started. These commands are not currently sourced for Wayland sessions.
        '';
      };

      hiddenUsers = mkOption {
        type = types.listOf types.str;
        default = [ "nobody" ];
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          A list of packages containing x11 or wayland session files to be passed to the display manager.
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
        description = lib.mdDoc ''
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

      sessionData = mkOption {
        description = lib.mdDoc "Data exported for display managers’ convenience";
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
        defaultText = literalMD ''
          Taken from display manager settings or window manager settings, if either is set.
        '';
        example = "gnome";
        description = lib.mdDoc ''
          Graphical session to pre-select in the session chooser (only effective for GDM, LightDM and SDDM).

          On GDM, LightDM and SDDM, it will also be used as a session for auto-login.
        '';
      };

      importedVariables = mkOption {
        type = types.listOf (types.strMatching "[a-zA-Z_][a-zA-Z0-9_]*");
        visible = false;
        description = lib.mdDoc ''
          Environment variables to import into the systemd user environment.
        '';
      };

      job = {

        preStart = mkOption {
          type = types.lines;
          default = "";
          example = "rm -f /var/log/my-display-manager.log";
          description = lib.mdDoc "Script executed before the display manager is started.";
        };

        execCmd = mkOption {
          type = types.str;
          example = literalExpression ''"''${pkgs.lightdm}/bin/lightdm"'';
          description = lib.mdDoc "Command to start the display manager.";
        };

        environment = mkOption {
          type = types.attrsOf types.unspecified;
          default = {};
          description = lib.mdDoc "Additional environment variables needed by the display manager.";
        };

        logToFile = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Whether the display manager redirects the output of the
            session script to {file}`~/.xsession-errors`.
          '';
        };

        logToJournal = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether the display manager redirects the output of the
            session script to the systemd journal.
          '';
        };

      };

      # Configuration for automatic login. Common for all DM.
      autoLogin = mkOption {
        type = types.submodule ({ config, options, ... }: {
          options = {
            enable = mkOption {
              type = types.bool;
              default = config.user != null;
              defaultText = literalExpression "config.${options.user} != null";
              description = lib.mdDoc ''
                Automatically log in as {option}`autoLogin.user`.
              '';
            };

            user = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = lib.mdDoc ''
                User to be used for the automatic login.
              '';
            };
          };
        });

        default = {};
        description = lib.mdDoc ''
          Auto login configuration attrset.
        '';
      };

    };

  };

  config = {
    assertions = [
      { assertion = cfg.displayManager.autoLogin.enable -> cfg.displayManager.autoLogin.user != null;
        message = ''
          services.xserver.displayManager.autoLogin.enable requires services.xserver.displayManager.autoLogin.user to be set
        '';
      }
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

    services.xserver.displayManager.importedVariables = [
      # This is required by user units using the session bus.
      "DBUS_SESSION_BUS_ADDRESS"
      # These are needed by the ssh-agent unit.
      "DISPLAY"
      "XAUTHORITY"
      # This is required to specify session within user units (e.g. loginctl lock-session).
      "XDG_SESSION_ID"
    ];

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

          /run/current-system/systemd/bin/systemctl --user stop graphical-session.target

          exit 0
        '';
      in
        # We will generate every possible pair of WM and DM.
        concatLists (
            builtins.map
            ({dm, wm}: let
              sessionName = "${dm.name}${optionalString (wm.name != "none") ("+" + wm.name)}";
              script = xsession dm wm;
              desktopNames = if dm ? desktopNames
                             then concatStringsSep ";" dm.desktopNames
                             else sessionName;
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
                    DesktopNames=${desktopNames}
                  '';
                } // {
                  providedSessions = [ sessionName ];
                })
            )
            (cartesianProductOfSets { dm = dms; wm = wms; })
          );

    # Make xsessions and wayland sessions available in XDG_DATA_DIRS
    # as some programs have behavior that depends on them being present
    environment.sessionVariables.XDG_DATA_DIRS = [
      "${cfg.displayManager.sessionData.desktops}/share"
    ];
  };

  imports = [
    (mkRemovedOptionModule [ "services" "xserver" "displayManager" "desktopManagerHandlesLidAndPower" ]
     "The option is no longer necessary because all display managers have already delegated lid management to systemd.")
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "job" "logsXsession" ] [ "services" "xserver" "displayManager" "job" "logToFile" ])
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "logToJournal" ] [ "services" "xserver" "displayManager" "job" "logToJournal" ])
    (mkRenamedOptionModule [ "services" "xserver" "displayManager" "extraSessionFilesPackages" ] [ "services" "xserver" "displayManager" "sessionPackages" ])
  ];

}
