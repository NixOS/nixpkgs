{ config, lib, pkgs, pkgs_i686, ... }:

with lib;

let

  kernelPackages = config.boot.kernelPackages;

  # Abbreviations.
  cfg = config.services.xserver;
  xorg = pkgs.xorg;


  # Map video driver names to driver packages. FIXME: move into card-specific modules.
  knownVideoDrivers = {
    virtualbox = { modules = [ kernelPackages.virtualboxGuestAdditions ]; driverName = "vboxvideo"; };

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
      description = ''
        The output name of the monitor, as shown by <citerefentry>
          <refentrytitle>xrandr</refentrytitle>
          <manvolnum>1</manvolnum>
        </citerefentry> invoked without arguments.
      '';
    };

    primary = mkOption {
      type = types.bool;
      default = false;
      description = ''
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
      description = ''
        Extra lines to append to the <literal>Monitor</literal> section
        verbatim.
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
    monitors = flip map xrandrHeads (h: ''
      Option "monitor-${h.config.output}" "${h.name}"
    '');
    # First option is indented through the space in the config but any
    # subsequent options aren't so we need to apply indentation to
    # them here
    monitorsIndented = if length monitors > 1
      then singleton (head monitors) ++ map (m: "  " + m) (tail monitors)
      else monitors;
  in concatStrings monitorsIndented;

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
    { xfs = optionalString (cfg.useXFS != false)
        ''FontPath "${toString cfg.useXFS}"'';
      inherit (cfg) config;
    }
      ''
        echo 'Section "Files"' >> $out
        echo $xfs >> $out

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

        echo 'EndSection' >> $out

        echo "$config" >> $out
      ''; # */

in

{

  imports =
    [ ./display-managers/default.nix
      ./window-managers/default.nix
      ./desktop-managers/default.nix
    ];


  ###### interface

  options = {

    services.xserver = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the X server.
        '';
      };

      plainX = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether the X11 session can be plain (without DM/WM) and
          the Xsession script will be used as fallback or not.
        '';
      };

      autorun = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to start the X server automatically.
        '';
      };

      exportConfiguration = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to symlink the X server configuration under
          <filename>/etc/X11/xorg.conf</filename>.
        '';
      };

      enableTCP = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to allow the X server to accept TCP connections.
        '';
      };

      autoRepeatDelay = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Sets the autorepeat delay (length of time in milliseconds that a key must be depressed before autorepeat starts).
        '';
      };

      autoRepeatInterval = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
          Sets the autorepeat interval (length of time in milliseconds that should elapse between autorepeat-generated keystrokes).
        '';
      };

      inputClassSections = mkOption {
        type = types.listOf types.lines;
        default = [];
        example = literalExample ''
          [ '''
              Identifier      "Trackpoint Wheel Emulation"
              MatchProduct    "ThinkPad USB Keyboard with TrackPoint"
              Option          "EmulateWheel"          "true"
              Option          "EmulateWheelButton"    "2"
              Option          "Emulate3Buttons"       "false"
            '''
          ]
        '';
        description = "Content of additional InputClass sections of the X server configuration file.";
      };

      modules = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExample "[ pkgs.xf86_input_wacom ]";
        description = "Packages to be added to the module search path of the X server.";
      };

      resolutions = mkOption {
        type = types.listOf types.attrs;
        default = [];
        example = [ { x = 1600; y = 1200; } { x = 1024; y = 786; } ];
        description = ''
          The screen resolutions for the X server.  The first element
          is the default resolution.  If this list is empty, the X
          server will automatically configure the resolution.
        '';
      };

      videoDrivers = mkOption {
        type = types.listOf types.str;
        # !!! We'd like "nv" here, but it segfaults the X server.
        default = [ "ati" "cirrus" "intel" "vesa" "vmware" "modesetting" ];
        example = [ "vesa" ];
        description = ''
          The names of the video drivers the configuration
          supports. They will be tried in order until one that
          supports your card is found.
        '';
      };

      videoDriver = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "i810";
        description = ''
          The name of the video driver for your graphics card.  This
          option is obsolete; please set the
          <option>services.xserver.videoDrivers</option> instead.
        '';
      };

      drivers = mkOption {
        type = types.listOf types.attrs;
        internal = true;
        description = ''
          A list of attribute sets specifying drivers to be loaded by
          the X11 server.
        '';
      };

      dpi = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "DPI resolution to use for X server.";
      };

      startDbusSession = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to start a new DBus session when you log in with dbus-launch.
        '';
      };

      updateDbusEnvironment = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to update the DBus activation environment after launching the
          desktop manager.
        '';
      };

      layout = mkOption {
        type = types.str;
        default = "us";
        description = ''
          Keyboard layout, or multiple keyboard layouts separated by commas.
        '';
      };

      xkbModel = mkOption {
        type = types.str;
        default = "pc104";
        example = "presario";
        description = ''
          Keyboard model.
        '';
      };

      xkbOptions = mkOption {
        type = types.str;
        default = "terminate:ctrl_alt_bksp";
        example = "grp:caps_toggle, grp_led:scroll";
        description = ''
          X keyboard options; layout switching goes here.
        '';
      };

      xkbVariant = mkOption {
        type = types.str;
        default = "";
        example = "colemak";
        description = ''
          X keyboard variant.
        '';
      };

      xkbDir = mkOption {
        type = types.path;
        description = ''
          Path used for -xkbdir xserver parameter.
        '';
      };

      config = mkOption {
        type = types.lines;
        description = ''
          The contents of the configuration file of the X server
          (<filename>xorg.conf</filename>).
        '';
      };

      deviceSection = mkOption {
        type = types.lines;
        default = "";
        example = "VideoRAM 131072";
        description = "Contents of the first Device section of the X server configuration file.";
      };

      screenSection = mkOption {
        type = types.lines;
        default = "";
        example = ''
          Option "RandRRotation" "on"
        '';
        description = "Contents of the first Screen section of the X server configuration file.";
      };

      monitorSection = mkOption {
        type = types.lines;
        default = "";
        example = "HorizSync 28-49";
        description = "Contents of the first Monitor section of the X server configuration file.";
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
        description = ''
          Multiple monitor configuration, just specify a list of XRandR
          outputs. The individual elements should be either simple strings or
          an attribute set of output options.

          If the element is a string, it is denoting the physical output for a
          monitor, if it's an attribute set, you must at least provide the
          <option>output</option> option.

          The monitors will be mapped from left to right in the order of the
          list.

          By default, the first monitor will be set as the primary monitor if
          none of the elements contain an option that has set
          <option>primary</option> to <literal>true</literal>.

          <note><para>Only one monitor is allowed to be primary.</para></note>

          Be careful using this option with multiple graphic adapters or with
          drivers that have poor support for XRandR, unexpected things might
          happen with those.
        '';
      };

      serverFlagsSection = mkOption {
        default = "";
        example =
          ''
          Option "BlankTime" "0"
          Option "StandbyTime" "0"
          Option "SuspendTime" "0"
          Option "OffTime" "0"
          '';
        description = "Contents of the ServerFlags section of the X server configuration file.";
      };

      moduleSection = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            SubSection "extmod"
            EndSubsection
          '';
        description = "Contents of the Module section of the X server configuration file.";
      };

      serverLayoutSection = mkOption {
        type = types.lines;
        default = "";
        example =
          ''
            Option "AIGLX" "true"
          '';
        description = "Contents of the ServerLayout section of the X server configuration file.";
      };

      extraDisplaySettings = mkOption {
        type = types.lines;
        default = "";
        example = "Virtual 2048 2048";
        description = "Lines to be added to every Display subsection of the Screen section.";
      };

      defaultDepth = mkOption {
        type = types.int;
        default = 0;
        example = 8;
        description = "Default colour depth.";
      };

      useXFS = mkOption {
        # FIXME: what's the type of this option?
        default = false;
        example = "unix/:7100";
        description = "Determines how to connect to the X Font Server.";
      };

      tty = mkOption {
        type = types.nullOr types.int;
        default = 7;
        description = "Virtual console for the X server.";
      };

      display = mkOption {
        type = types.nullOr types.int;
        default = 0;
        description = "Display number for the X server.";
      };

      virtualScreen = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        example = { x = 2048; y = 2048; };
        description = ''
          Virtual screen size for Xrandr.
        '';
      };

      verbose = mkOption {
        type = types.nullOr types.int;
        default = 3;
        example = 7;
        description = ''
          Controls verbosity of X logging.
        '';
      };

      useGlamor = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use the Glamor module for 2D acceleration,
          if possible.
        '';
      };

      enableCtrlAltBackspace = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the DontZap option, which binds Ctrl+Alt+Backspace
          to forcefully kill X. This can lead to data loss and is disabled
          by default.
        '';
      };

      terminateOnReset = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to terminate X upon server reset.
        '';
      };
    };

  };



  ###### implementation

  config = mkIf cfg.enable {

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
      in optional (driver != null) ({ inherit name; modules = []; driverName = name; } // driver));

    nixpkgs.config = optionalAttrs (elem "vboxvideo" cfg.videoDrivers) { xorg.abiCompat = "1.18"; };

    assertions = [
      { assertion = config.security.polkit.enable;
        message = "X11 requires Polkit to be enabled (‘security.polkit.enable = true’).";
      }
      (let primaryHeads = filter (x: x.primary) cfg.xrandrHeads; in {
        assertion = length primaryHeads < 2;
        message = "Only one head is allowed to be primary in "
                + "‘services.xserver.xrandrHeads’, but there are "
                + "${toString (length primaryHeads)} heads set to primary: "
                + concatMapStringsSep ", " (x: x.output) primaryHeads;
      })
      { assertion = cfg.desktopManager.default == "none" && cfg.windowManager.default == "none" -> cfg.plainX;
        message = "Either the desktop manager or the window manager shouldn't be `none`! "
                + "To explicitly allow this, you can also set `services.xserver.plainX` to `true`. "
                + "The `default` value looks for enabled WMs/DMs and select the first one.";
      }
    ];

    environment.etc =
      (optionals cfg.exportConfiguration
        [ { source = "${configFile}";
            target = "X11/xorg.conf";
          }
          # -xkbdir command line option does not seems to be passed to xkbcomp.
          { source = "${cfg.xkbDir}";
            target = "X11/xkb";
          }
        ])
      # localectl looks into 00-keyboard.conf
      ++ [
        {
          text = ''
            Section "InputClass"
              Identifier "Keyboard catchall"
              MatchIsKeyboard "on"
              Option "XkbModel" "${cfg.xkbModel}"
              Option "XkbLayout" "${cfg.layout}"
              Option "XkbOptions" "${cfg.xkbOptions}"
              Option "XkbVariant" "${cfg.xkbVariant}"
            EndSection
          '';
          target = "X11/xorg.conf.d/00-keyboard.conf";
        }
      ]
      # Needed since 1.18; see https://bugs.freedesktop.org/show_bug.cgi?id=89023#c5
      ++ (let cfgPath = "/X11/xorg.conf.d/10-evdev.conf"; in
        [{
          source = xorg.xf86inputevdev.out + "/share" + cfgPath;
          target = cfgPath;
        }]
      );

    environment.systemPackages =
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
        pkgs.xdg_utils
        xorg.xf86inputevdev.out # get evdev.4 man page
      ]
      ++ optional (elem "virtualbox" cfg.videoDrivers) xorg.xrefresh;

    environment.pathsToLink =
      [ "/etc/xdg" "/share/xdg" "/share/applications" "/share/icons" "/share/pixmaps" ];

    # The default max inotify watches is 8192.
    # Nowadays most apps require a good number of inotify watches,
    # the value below is used by default on several other distros.
    boot.kernel.sysctl."fs.inotify.max_user_watches" = mkDefault 524288;

    systemd.defaultUnit = mkIf cfg.autorun "graphical.target";

    systemd.services.display-manager =
      { description = "X11 Server";

        after = [ "systemd-udev-settle.service" "local-fs.target" "acpid.service" "systemd-logind.service" ];
        wants = [ "systemd-udev-settle.service" ];

        restartIfChanged = false;

        environment =
          {
            LD_LIBRARY_PATH = concatStringsSep ":" ([ "/run/opengl-driver/lib" ]
              ++ concatLists (catAttrs "libPath" cfg.drivers));
          } // cfg.displayManager.job.environment;

        preStart =
          ''
            ${cfg.displayManager.job.preStart}

            rm -f /tmp/.X0-lock
          '';

        script = "${cfg.displayManager.job.execCmd}";

        serviceConfig = {
          Restart = "always";
          RestartSec = "200ms";
          SyslogIdentifier = "display-manager";
          # Stop restarting if the display manager stops (crashes) 2 times
          # in one minute. Starting X typically takes 3-4s.
          StartLimitInterval = "30s";
          StartLimitBurst = "3";
        };
      };

    services.xserver.displayManager.xserverArgs =
      [ "-config ${configFile}"
        "-xkbdir" "${cfg.xkbDir}"
        # Log at the default verbosity level to stderr rather than /var/log/X.*.log.
         "-logfile" "/dev/null"
      ] ++ optional (cfg.display != null) ":${toString cfg.display}"
        ++ optional (cfg.tty     != null) "vt${toString cfg.tty}"
        ++ optional (cfg.dpi     != null) "-dpi ${toString cfg.dpi}"
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

    services.xserver.xkbDir = mkDefault "${pkgs.xkeyboard_config}/etc/X11/xkb";

    system.extraDependencies = singleton (pkgs.runCommand "xkb-validated" {
      inherit (cfg) xkbModel layout xkbVariant xkbOptions;
      nativeBuildInputs = [ pkgs.xkbvalidate ];
    } ''
      validate "$xkbModel" "$layout" "$xkbVariant" "$xkbOptions"
      touch "$out"
    '');

    services.xserver.config =
      ''
        Section "ServerFlags"
          Option "AllowMouseOpenFail" "on"
          Option "DontZap" "${if cfg.enableCtrlAltBackspace then "off" else "on"}"
          ${cfg.serverFlagsSection}
        EndSection

        Section "Module"
          ${cfg.moduleSection}
        EndSection

        Section "Monitor"
          Identifier "Monitor[0]"
          ${cfg.monitorSection}
        EndSection

        # Additional "InputClass" sections
        ${flip concatMapStrings cfg.inputClassSections (inputClassSection: ''
        Section "InputClass"
          ${inputClassSection}
        EndSection
        '')}


        Section "ServerLayout"
          Identifier "Layout[all]"
          ${cfg.serverLayoutSection}
          # Reference the Screen sections for each driver.  This will
          # cause the X server to try each in turn.
          ${flip concatMapStrings cfg.drivers (d: ''
            Screen "Screen-${d.name}[0]"
          '')}
        EndSection

        ${if cfg.useGlamor then ''
          Section "Module"
            Load "dri2"
            Load "glamoregl"
          EndSection
        '' else ""}

        # For each supported driver, add a "Device" and "Screen"
        # section.
        ${flip concatMapStrings cfg.drivers (driver: ''

          Section "Device"
            Identifier "Device-${driver.name}[0]"
            Driver "${driver.driverName or driver.name}"
            ${if cfg.useGlamor then ''Option "AccelMethod" "glamor"'' else ""}
            ${cfg.deviceSection}
            ${xrandrDeviceSection}
          EndSection

          Section "Screen"
            Identifier "Screen-${driver.name}[0]"
            Device "Device-${driver.name}[0]"
            ${optionalString (cfg.monitorSection != "") ''
              Monitor "Monitor[0]"
            ''}

            ${cfg.screenSection}

            ${optionalString (cfg.defaultDepth != 0) ''
              DefaultDepth ${toString cfg.defaultDepth}
            ''}

            ${optionalString
                (driver.name != "virtualbox" &&
                 (cfg.resolutions != [] ||
                  cfg.extraDisplaySettings != "" ||
                  cfg.virtualScreen != null))
              (let
                f = depth:
                  ''
                    SubSection "Display"
                      Depth ${toString depth}
                      ${optionalString (cfg.resolutions != [])
                        "Modes ${concatMapStrings (res: ''"${toString res.x}x${toString res.y}"'') cfg.resolutions}"}
                      ${cfg.extraDisplaySettings}
                      ${optionalString (cfg.virtualScreen != null)
                        "Virtual ${toString cfg.virtualScreen.x} ${toString cfg.virtualScreen.y}"}
                    EndSubSection
                  '';
              in concatMapStrings f [8 16 24]
            )}

          EndSection
        '')}

        ${xrandrMonitorSections}
      '';

    fonts.enableDefaultFonts = mkDefault true;

  };

}
