{ config, lib, utils, pkgs, ... }:

with lib;

let

  # Abbreviations.
  cfg = config.services.xserver;
  xorg = pkgs.xorg;


  # Map video driver names to driver packages. FIXME: move into card-specific modules.
  knownVideoDrivers = {
    # Alias so people can keep using "virtualbox" instead of "vboxvideo".
    virtualbox = { modules = [ xorg.xf86videovboxvideo ]; driverName = "vboxvideo"; };

    # Alias so that "radeon" uses the xf86-video-ati driver.
    radeon = { modules = [ xorg.xf86videoati ]; driverName = "ati"; };

    # modesetting does not have a xf86videomodesetting package as it is included in xorgserver
    modesetting = {};
  };

  fontsForXServer =
    config.fonts.fonts ++
    # We don't want these fonts in fonts.conf, because then modern,
    # fontconfig-based applications will get horrible bitmapped
    # Helvetica fonts.  It's better to get a substitution (like Nimbus
    # Sans) than that horror.  But we do need the Adobe fonts for some
    # old non-fontconfig applications.  (Possibly this could be done
    # better using a fontconfig rule.)
    [ pkgs.xorg.fontadobe100dpi
      pkgs.xorg.fontadobe75dpi
    ];

  xrandrOptions = {
    output = mkOption {
      type = types.str;
      example = "DVI-0";
      description = lib.mdDoc ''
        The output name of the monitor, as shown by
        {manpage}`xrandr(1)` invoked without arguments.
      '';
    };

    primary = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether this head is treated as the primary monitor,
      '';
    };

    monitorConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        DisplaySize 408 306
        Option "DPMS" "false"
      '';
      description = lib.mdDoc ''
        Extra lines to append to the `Monitor` section
        verbatim. Available options are documented in the MONITOR section in
        {manpage}`xorg.conf(5)`.
      '';
    };
  };

  # Just enumerate all heads without discarding XRandR output information.
  xrandrHeads = let
    mkHead = num: config: {
      name = "multihead${toString num}";
      inherit config;
    };
  in imap1 mkHead cfg.xrandrHeads;

  xrandrDeviceSection = let
    monitors = forEach xrandrHeads (h: ''
      Option "monitor-${h.config.output}" "${h.name}"
    '');
  in concatStrings monitors;

  # Here we chain every monitor from the left to right, so we have:
  # m4 right of m3 right of m2 right of m1   .----.----.----.----.
  # Which will end up in reverse ----------> | m1 | m2 | m3 | m4 |
  #                                          `----^----^----^----'
  xrandrMonitorSections = let
    mkMonitor = previous: current: singleton {
      inherit (current) name;
      value = ''
        Section "Monitor"
          Identifier "${current.name}"
          ${optionalString (current.config.primary) ''
          Option "Primary" "true"
          ''}
          ${optionalString (previous != []) ''
          Option "RightOf" "${(head previous).name}"
          ''}
          ${current.config.monitorConfig}
        EndSection
      '';
    } ++ previous;
    monitors = reverseList (foldl mkMonitor [] xrandrHeads);
  in concatMapStrings (getAttr "value") monitors;

  configFile = pkgs.runCommand "xserver.conf"
    { fontpath = optionalString (cfg.fontPath != null)
        ''FontPath "${cfg.fontPath}"'';
      inherit (cfg) config;
      preferLocalBuild = true;
    }
      ''
        echo 'Section "Files"' >> $out
        echo $fontpath >> $out

        for i in ${toString fontsForXServer}; do
          if test "''${i:0:''${#NIX_STORE}}" == "$NIX_STORE"; then
            for j in $(find $i -name fonts.dir); do
              echo "  FontPath \"$(dirname $j)\"" >> $out
            done
          fi
        done

        for i in $(find ${toString cfg.modules} -type d); do
          if test $(echo $i/*.so* | wc -w) -ne 0; then
            echo "  ModulePath \"$i\"" >> $out
          fi
        done

        echo '${cfg.filesSection}' >> $out
        echo 'EndSection' >> $out
        echo >> $out

        echo "$config" >> $out
      ''; # */

  prefixStringLines = prefix: str:
    concatMapStringsSep "\n" (line: prefix + line) (splitString "\n" str);

  indent = prefixStringLines "  ";
in

{

  imports =
    [ ./display-managers/default.nix
      ./window-managers/default.nix
      ./desktop-managers/default.nix
      (mkRemovedOptionModule [ "services" "xserver" "startGnuPGAgent" ]
        "See the 16.09 release notes for more information.")
      (mkRemovedOptionModule
        [ "services" "xserver" "startDbusSession" ]
        "The user D-Bus session is now always socket activated and this option can safely be removed.")
      (mkRemovedOptionModule [ "services" "xserver" "useXFS" ]
        "Use services.xserver.fontPath instead of useXFS")
      (mkRemovedOptionModule [ "services" "xserver" "useGlamor" ]
        "Option services.xserver.useGlamor was removed because it is unnecessary. Drivers that uses Glamor will use it automatically.")
    ];


  ###### interface

  options = {

    services.xserver = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the X server.
        '';
      };

      autorun = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to start the X server automatically.
        '';
      };

      excludePackages = mkOption {
        default = [];
        example = literalExpression "[ pkgs.xterm ]";
        type = types.listOf types.package;
        description = lib.mdDoc "Which X11 packages to exclude from the default environment";
      };

      exportConfiguration = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to symlink the X server configuration under
          {file}`/etc/X11/xorg.conf`.
        '';
      };

      enableTCP = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to allow the X server to accept TCP connections.
        '';
      };

      autoRepeatDelay = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc ''
          Sets the autorepeat delay (length of time in milliseconds that a key must be depressed before autorepeat starts).
        '';
      };

      autoRepeatInterval = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc ''
          Sets the autorepeat interval (length of time in milliseconds that should elapse between autorepeat-generated keystrokes).
        '';
      };

      inputClassSections = mkOption {
        type = types.listOf types.lines;
        default = [];
        example = literalExpression ''
          [ '''
              Identifier      "Trackpoint Wheel Emulation"
              MatchProduct    "ThinkPad USB Keyboard with TrackPoint"
              Option          "EmulateWheel"          "true"
              Option          "EmulateWheelButton"    "2"
              Option          "Emulate3Buttons"       "false"
            '''
          ]
        '';
        description = lib.mdDoc "Content of additional InputClass sections of the X server configuration file.";
      };

      modules = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExpression "[ pkgs.xf86_input_wacom ]";
        description = lib.mdDoc "Packages to be added to the module search path of the X server.";
      };

      resolutions = mkOption {
        type = types.listOf types.attrs;
        default = [];
        example = [ { x = 1600; y = 1200; } { x = 1024; y = 786; } ];
        description = lib.mdDoc ''
          The screen resolutions for the X server.  The first element
          is the default resolution.  If this list is empty, the X
          server will automatically configure the resolution.
        '';
      };

      videoDrivers = mkOption {
        type = types.listOf types.str;
        default = [ "amdgpu" "radeon" "nouveau" "modesetting" "fbdev" ];
        example = [
          "nvidia" "nvidiaLegacy390" "nvidiaLegacy340" "nvidiaLegacy304"
          "amdgpu-pro"
        ];
        # TODO(@oxij): think how to easily add the rest, like those nvidia things
        relatedPackages = concatLists
          (mapAttrsToList (n: v:
            optional (hasPrefix "xf86video" n) {
              path  = [ "xorg" n ];
              title = removePrefix "xf86video" n;
            }) pkgs.xorg);
        description = lib.mdDoc ''
          The names of the video drivers the configuration
          supports. They will be tried in order until one that
          supports your card is found.
          Don't combine those with "incompatible" OpenGL implementations,
          e.g. free ones (mesa-based) with proprietary ones.

          For unfree "nvidia*", the supported GPU lists are on
          https://www.nvidia.com/object/unix.html
        '';
      };

      videoDriver = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "i810";
        description = lib.mdDoc ''
          The name of the video driver for your graphics card.  This
          option is obsolete; please set the
          {option}`services.xserver.videoDrivers` instead.
        '';
      };

      drivers = mkOption {
        type = types.listOf types.attrs;
        internal = true;
        description = lib.mdDoc ''
          A list of attribute sets specifying drivers to be loaded by
          the X11 server.
        '';
      };

      dpi = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = lib.mdDoc ''
          Force global DPI resolution to use for X server. It's recommended to
          use this only when DPI is detected incorrectly; also consider using
          `Monitor` section in configuration file instead.
        '';
      };

      updateDbusEnvironment = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to update the DBus activation environment after launching the
          desktop manager.
        '';
      };

      layout = mkOption {
        type = types.str;
        default = "us";
        description = lib.mdDoc ''
          Keyboard layout, or multiple keyboard layouts separated by commas.
        '';
      };

      xkbModel = mkOption {
        type = types.str;
        default = "pc104";
        example = "presario";
        description = lib.mdDoc ''
          Keyboard model.
        '';
      };

      xkbOptions = mkOption {
        type = types.commas;
        default = "terminate:ctrl_alt_bksp";
        example = "grp:caps_toggle,grp_led:scroll";
        description = lib.mdDoc ''
          X keyboard options; layout switching goes here.
        '';
      };

      xkbVariant = mkOption {
        type = types.str;
        default = "";
        example = "colemak";
        description = lib.mdDoc ''
          X keyboard variant.
        '';
      };

      xkbDir = mkOption {
        type = types.path;
        default = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        defaultText = literalExpression ''"''${pkgs.xkeyboard_config}/etc/X11/xkb"'';
        description = lib.mdDoc ''
          Path used for -xkbdir xserver parameter.
        '';
      };

      config = mkOption {
        type = types.lines;
        description = lib.mdDoc ''
          The contents of the configuration file of the X server
          ({file}`xorg.conf`).

          This option is set by multiple modules, and the configs are
          concatenated together.

          In Xorg configs the last config entries take precedence,
          so you may want to use `lib.mkAfter` on this option
          to override NixOS's defaults.
        '';
      };

      filesSection = mkOption {
        type = types.lines;
        default = "";
        example = ''FontPath "/path/to/my/fonts"'';
        description = lib.mdDoc "Contents of the first `Files` section of the X server configuration file.";
      };

      deviceSection = mkOption {
        type = types.lines;
        default = "";
        example = "VideoRAM 131072";
        description = lib.mdDoc "Contents of the first Device section of the X server configuration file.";
      };

      screenSection = mkOption {
        type = types.lines;
        default = "";
        example = ''
          Option "RandRRotation" "on"
        '';
        description = lib.mdDoc "Contents of the first Screen section of the X server configuration file.";
      };

      monitorSection = mkOption {
        type = types.lines;
        default = "";
        example = "HorizSync 28-49";
        description = lib.mdDoc "Contents of the first Monitor section of the X server configuration file.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc "Additional contents (sections) included in the X server configuration file";
      };

      xrandrHeads = mkOption {
        default = [];
        example = [
          "HDMI-0"
          { output = "DVI-0"; primary = true; }
          { output = "DVI-1"; monitorConfig = "Option \"Rotate\" \"left\""; }
        ];
        type = with types; listOf (coercedTo str (output: {
          inherit output;
        }) (submodule { options = xrandrOptions; }));
        # Set primary to true for the first head if no other has been set
        # primary already.
        apply = heads: let
          hasPrimary = any (x: x.primary) heads;
          firstPrimary = head heads // { primary = true; };
          newHeads = singleton firstPrimary ++ tail heads;
        in if heads != [] && !hasPrimary then newHeads else heads;
        description = lib.mdDoc ''
          Multiple monitor configuration, just specify a list of XRandR
          outputs. The individual elements should be either simple strings or
          an attribute set of output options.

          If the element is a string, it is denoting the physical output for a
          monitor, if it's an attribute set, you must at least provide the
          {option}`output` option.

          The monitors will be mapped from left to right in the order of the
          list.

          By default, the first monitor will be set as the primary monitor if
          none of the elements contain an option that has set
          {option}`primary` to `true`.

          ::: {.note}
          Only one monitor is allowed to be primary.
          :::

          Be careful using this option with multiple graphic adapters or with
          drivers that have poor support for XRandR, unexpected things might
          happen with those.
        '';
      };

      serverFlagsSection = mkOption {
        default = "";
        type = types.lines;
        example =
          ''
          Option "BlankTime" "0"
          Option "StandbyTime" "0"
          Option "SuspendTime" "0"
          Option "OffTime" "0"
          '';
        description = lib.mdDoc "Contents of the ServerFlags section of the X server configuration file.";
      };

      moduleSection = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            SubSection "extmod"
            EndSubsection
          '';
        description = lib.mdDoc "Contents of the Module section of the X server configuration file.";
      };

      serverLayoutSection = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            Option "AIGLX" "true"
          '';
        description = lib.mdDoc "Contents of the ServerLayout section of the X server configuration file.";
      };

      extraDisplaySettings = mkOption {
        type = types.lines;
        default = "";
        example = "Virtual 2048 2048";
        description = lib.mdDoc "Lines to be added to every Display subsection of the Screen section.";
      };

      defaultDepth = mkOption {
        type = types.int;
        default = 0;
        example = 8;
        description = lib.mdDoc "Default colour depth.";
      };

      fontPath = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "unix/:7100";
        description = lib.mdDoc ''
          Set the X server FontPath. Defaults to null, which
          means the compiled in defaults will be used. See
          man xorg.conf for details.
        '';
      };

      tty = mkOption {
        type = types.nullOr types.int;
        default = 7;
        description = lib.mdDoc "Virtual console for the X server.";
      };

      display = mkOption {
        type = types.nullOr types.int;
        default = 0;
        description = lib.mdDoc "Display number for the X server.";
      };

      virtualScreen = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        example = { x = 2048; y = 2048; };
        description = lib.mdDoc ''
          Virtual screen size for Xrandr.
        '';
      };

      logFile = mkOption {
        type = types.nullOr types.str;
        default = "/dev/null";
        example = "/var/log/Xorg.0.log";
        description = lib.mdDoc ''
          Controls the file Xorg logs to.

          The default of `/dev/null` is set so that systemd services (like `displayManagers`) only log to the journal and don't create their own log files.

          Setting this to `null` will not pass the `-logfile` argument to Xorg which allows it to log to its default logfile locations instead (see `man Xorg`). You probably only want this behaviour when running Xorg manually (e.g. via `startx`).
        '';
      };

      verbose = mkOption {
        type = types.nullOr types.int;
        default = 3;
        example = 7;
        description = lib.mdDoc ''
          Controls verbosity of X logging.
        '';
      };

      enableCtrlAltBackspace = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the DontZap option, which binds Ctrl+Alt+Backspace
          to forcefully kill X. This can lead to data loss and is disabled
          by default.
        '';
      };

      terminateOnReset = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to terminate X upon server reset.
        '';
      };
    };

  };



  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.displayManager.lightdm.enable =
      let dmConf = cfg.displayManager;
          default = !(dmConf.gdm.enable
                    || dmConf.sddm.enable
                    || dmConf.xpra.enable
                    || dmConf.sx.enable
                    || dmConf.startx.enable);
      in mkIf (default) (mkDefault true);

    # so that the service won't be enabled when only startx is used
    systemd.services.display-manager.enable  =
      let dmConf = cfg.displayManager;
          noDmUsed = !(dmConf.gdm.enable
                    || dmConf.sddm.enable
                    || dmConf.xpra.enable
                    || dmConf.lightdm.enable);
      in mkIf (noDmUsed) (mkDefault false);

    hardware.opengl.enable = mkDefault true;

    services.xserver.videoDrivers = mkIf (cfg.videoDriver != null) [ cfg.videoDriver ];

    # FIXME: somehow check for unknown driver names.
    services.xserver.drivers = flip concatMap cfg.videoDrivers (name:
      let driver =
        attrByPath [name]
          (if xorg ? ${"xf86video" + name}
           then { modules = [xorg.${"xf86video" + name}]; }
           else null)
          knownVideoDrivers;
      in optional (driver != null) ({ inherit name; modules = []; driverName = name; display = true; } // driver));

    assertions = [
      (let primaryHeads = filter (x: x.primary) cfg.xrandrHeads; in {
        assertion = length primaryHeads < 2;
        message = "Only one head is allowed to be primary in "
                + "‘services.xserver.xrandrHeads’, but there are "
                + "${toString (length primaryHeads)} heads set to primary: "
                + concatMapStringsSep ", " (x: x.output) primaryHeads;
      })
    ];

    environment.etc =
      (optionalAttrs cfg.exportConfiguration
        {
          "X11/xorg.conf".source = "${configFile}";
          # -xkbdir command line option does not seems to be passed to xkbcomp.
          "X11/xkb".source = "${cfg.xkbDir}";
        })
      # localectl looks into 00-keyboard.conf
      //{
          "X11/xorg.conf.d/00-keyboard.conf".text = ''
            Section "InputClass"
              Identifier "Keyboard catchall"
              MatchIsKeyboard "on"
              Option "XkbModel" "${cfg.xkbModel}"
              Option "XkbLayout" "${cfg.layout}"
              Option "XkbOptions" "${cfg.xkbOptions}"
              Option "XkbVariant" "${cfg.xkbVariant}"
            EndSection
          '';
        }
      # Needed since 1.18; see https://bugs.freedesktop.org/show_bug.cgi?id=89023#c5
      // (let cfgPath = "/X11/xorg.conf.d/10-evdev.conf"; in
        {
          ${cfgPath}.source = xorg.xf86inputevdev.out + "/share" + cfgPath;
        });

    environment.systemPackages = utils.removePackagesByName
      [ xorg.xorgserver.out
        xorg.xrandr
        xorg.xrdb
        xorg.setxkbmap
        xorg.iceauth # required for KDE applications (it's called by dcopserver)
        xorg.xlsclients
        xorg.xset
        xorg.xsetroot
        xorg.xinput
        xorg.xprop
        xorg.xauth
        pkgs.xterm
        pkgs.xdg-utils
        xorg.xf86inputevdev.out # get evdev.4 man page
        pkgs.nixos-icons # needed for gnome and pantheon about dialog, nixos-manual and maybe more
      ] config.services.xserver.excludePackages
      ++ optional (elem "virtualbox" cfg.videoDrivers) xorg.xrefresh;

    environment.pathsToLink = [ "/share/X11" ];

    xdg = {
      autostart.enable = true;
      menus.enable = true;
      mime.enable = true;
      icons.enable = true;
    };

    # The default max inotify watches is 8192.
    # Nowadays most apps require a good number of inotify watches,
    # the value below is used by default on several other distros.
    boot.kernel.sysctl."fs.inotify.max_user_instances" = mkDefault 524288;
    boot.kernel.sysctl."fs.inotify.max_user_watches" = mkDefault 524288;

    systemd.defaultUnit = mkIf cfg.autorun "graphical.target";

    systemd.services.display-manager =
      { description = "X11 Server";

        after = [ "acpid.service" "systemd-logind.service" "systemd-user-sessions.service" ];

        restartIfChanged = false;

        environment =
          optionalAttrs config.hardware.opengl.setLdLibraryPath
            { LD_LIBRARY_PATH = lib.makeLibraryPath [ pkgs.addOpenGLRunpath.driverLink ]; }
          // cfg.displayManager.job.environment;

        preStart =
          ''
            ${cfg.displayManager.job.preStart}

            rm -f /tmp/.X0-lock
          '';

        # TODO: move declaring the systemd service to its own mkIf
        script = mkIf (config.systemd.services.display-manager.enable == true) "${cfg.displayManager.job.execCmd}";

        # Stop restarting if the display manager stops (crashes) 2 times
        # in one minute. Starting X typically takes 3-4s.
        startLimitIntervalSec = 30;
        startLimitBurst = 3;
        serviceConfig = {
          Restart = "always";
          RestartSec = "200ms";
          SyslogIdentifier = "display-manager";
        };
      };

    services.xserver.displayManager.xserverArgs =
      [ "-config ${configFile}"
        "-xkbdir" "${cfg.xkbDir}"
      ] ++ optional (cfg.display != null) ":${toString cfg.display}"
        ++ optional (cfg.tty     != null) "vt${toString cfg.tty}"
        ++ optional (cfg.dpi     != null) "-dpi ${toString cfg.dpi}"
        ++ optional (cfg.logFile != null) "-logfile ${toString cfg.logFile}"
        ++ optional (cfg.verbose != null) "-verbose ${toString cfg.verbose}"
        ++ optional (!cfg.enableTCP) "-nolisten tcp"
        ++ optional (cfg.autoRepeatDelay != null) "-ardelay ${toString cfg.autoRepeatDelay}"
        ++ optional (cfg.autoRepeatInterval != null) "-arinterval ${toString cfg.autoRepeatInterval}"
        ++ optional cfg.terminateOnReset "-terminate";

    services.xserver.modules =
      concatLists (catAttrs "modules" cfg.drivers) ++
      [ xorg.xorgserver.out
        xorg.xf86inputevdev.out
      ];

    system.extraDependencies = singleton (pkgs.runCommand "xkb-validated" {
      inherit (cfg) xkbModel layout xkbVariant xkbOptions;
      nativeBuildInputs = with pkgs.buildPackages; [ xkbvalidate ];
      preferLocalBuild = true;
    } ''
      ${optionalString (config.environment.sessionVariables ? XKB_CONFIG_ROOT)
        "export XKB_CONFIG_ROOT=${config.environment.sessionVariables.XKB_CONFIG_ROOT}"
      }
      xkbvalidate "$xkbModel" "$layout" "$xkbVariant" "$xkbOptions"
      touch "$out"
    '');

    services.xserver.config =
      ''
        Section "ServerFlags"
          Option "AllowMouseOpenFail" "on"
          Option "DontZap" "${if cfg.enableCtrlAltBackspace then "off" else "on"}"
        ${indent cfg.serverFlagsSection}
        EndSection

        Section "Module"
        ${indent cfg.moduleSection}
        EndSection

        Section "Monitor"
          Identifier "Monitor[0]"
        ${indent cfg.monitorSection}
        EndSection

        # Additional "InputClass" sections
        ${flip (concatMapStringsSep "\n") cfg.inputClassSections (inputClassSection: ''
          Section "InputClass"
          ${indent inputClassSection}
          EndSection
        '')}


        Section "ServerLayout"
          Identifier "Layout[all]"
        ${indent cfg.serverLayoutSection}
          # Reference the Screen sections for each driver.  This will
          # cause the X server to try each in turn.
          ${flip concatMapStrings (filter (d: d.display) cfg.drivers) (d: ''
            Screen "Screen-${d.name}[0]"
          '')}
        EndSection

        # For each supported driver, add a "Device" and "Screen"
        # section.
        ${flip concatMapStrings cfg.drivers (driver: ''

          Section "Device"
            Identifier "Device-${driver.name}[0]"
            Driver "${driver.driverName or driver.name}"
          ${indent cfg.deviceSection}
          ${indent (driver.deviceSection or "")}
          ${indent xrandrDeviceSection}
          EndSection
          ${optionalString driver.display ''

            Section "Screen"
              Identifier "Screen-${driver.name}[0]"
              Device "Device-${driver.name}[0]"
              ${optionalString (cfg.monitorSection != "") ''
                Monitor "Monitor[0]"
              ''}

            ${indent cfg.screenSection}
            ${indent (driver.screenSection or "")}

              ${optionalString (cfg.defaultDepth != 0) ''
                DefaultDepth ${toString cfg.defaultDepth}
              ''}

              ${optionalString
                (
                  driver.name != "virtualbox"
                  &&
                  (cfg.resolutions != [] ||
                    cfg.extraDisplaySettings != "" ||
                    cfg.virtualScreen != null
                  )
                )
                (let
                  f = depth:
                    ''
                      SubSection "Display"
                        Depth ${toString depth}
                        ${optionalString (cfg.resolutions != [])
                          "Modes ${concatMapStrings (res: ''"${toString res.x}x${toString res.y}"'') cfg.resolutions}"}
                      ${indent cfg.extraDisplaySettings}
                        ${optionalString (cfg.virtualScreen != null)
                          "Virtual ${toString cfg.virtualScreen.x} ${toString cfg.virtualScreen.y}"}
                      EndSubSection
                    '';
                in concatMapStrings f [8 16 24]
              )}

            EndSection
          ''}
        '')}

        ${xrandrMonitorSections}

        ${cfg.extraConfig}
      '';

    fonts.enableDefaultFonts = mkDefault true;

  };

  # uses relatedPackages
  meta.buildDocsInSandbox = false;
}
