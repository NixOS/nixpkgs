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
    ati = { modules = with pkgs.xorg; [ xf86videoati glamoregl ]; };
    intel = { modules = with pkgs.xorg; [ xf86videointel glamoregl ]; };
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


  # Just enumerate all heads without discarding XRandR output information.
  xrandrHeads = let
    mkHead = num: output: {
      name = "multihead${toString num}";
      inherit output;
    };
  in imap mkHead cfg.xrandrHeads;

  xrandrDeviceSection = let
    monitors = flip map xrandrHeads (h: ''
      Option "monitor-${h.output}" "${h.name}"
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
          ${optionalString (previous != []) ''
          Option "RightOf" "${(head previous).name}"
          ''}
        EndSection
      '';
    } ++ previous;
    monitors = reverseList (foldl mkMonitor [] xrandrHeads);
  in concatMapStrings (getAttr "value") monitors;

  configFile = pkgs.stdenv.mkDerivation {
    name = "xserver.conf";

    xfs = optionalString (cfg.useXFS != false)
      ''FontPath "${toString cfg.useXFS}"'';

    inherit (cfg) config;

    buildCommand =
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
  };

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

      inputClassSections = mkOption {
        type = types.listOf types.lines;
        default = [];
        example = literalExample ''
          [ '''
              Identifier      "Trackpoint Wheel Emulation"
              MatchProduct    "ThinkPad USB Keyboard with TrackPoint"
              Option          "EmulateWheel"          "true
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

      startGnuPGAgent = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to start the GnuPG agent when you log in.  The GnuPG agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection or sign/encrypt
          data.  Use <command>ssh-add</command> to add a key to the agent.
        '';
      };

      startDbusSession = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to start a new DBus session when you log in with dbus-launch.
        '';
      };

      layout = mkOption {
        type = types.str;
        default = "us";
        description = ''
          Keyboard layout.
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
        example = [ "HDMI-0" "DVI-0" ];
        type = with types; listOf string;
        description = ''
          Simple multiple monitor configuration, just specify a list of XRandR
          outputs which will be mapped from left to right in the order of the
          list.

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
      in optional (driver != null) ({ inherit name; driverName = name; } // driver));

    assertions =
      [ { assertion = !(config.programs.ssh.startAgent && cfg.startGnuPGAgent);
          message =
            ''
              The OpenSSH agent and GnuPG agent cannot be started both. Please
              choose between ‘programs.ssh.startAgent’ and ‘services.xserver.startGnuPGAgent’.
            '';
        }
        { assertion = config.security.polkit.enable;
          message = "X11 requires Polkit to be enabled (‘security.polkit.enable = true’).";
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
        ]);

    environment.systemPackages =
      [ xorg.xorgserver
        xorg.xrandr
        xorg.xrdb
        xorg.setxkbmap
        xorg.iceauth # required for KDE applications (it's called by dcopserver)
        xorg.xlsclients
        xorg.xset
        xorg.xsetroot
        xorg.xinput
        xorg.xprop
        pkgs.xterm
        pkgs.xdg_utils
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

        restartIfChanged = false;

        environment =
          {
            XKB_BINDIR = "${xorg.xkbcomp}/bin"; # Needed for the Xkb extension.
            XORG_DRI_DRIVER_PATH = "/run/opengl-driver/lib/dri"; # !!! Depends on the driver selected at runtime.
            LD_LIBRARY_PATH = concatStringsSep ":" (
              [ "${xorg.libX11}/lib" "${xorg.libXext}/lib" ]
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
        };
      };

    services.xserver.displayManager.xserverArgs =
      [ "-terminate"
        "-config ${configFile}"
        "-xkbdir" "${cfg.xkbDir}"
      ] ++ optional (cfg.display != null) ":${toString cfg.display}"
        ++ optional (cfg.tty     != null) "vt${toString cfg.tty}"
        ++ optionals (cfg.display != null) [ "-logfile" "/var/log/X.${toString cfg.display}.log" ]
        ++ optional (!cfg.enableTCP) "-nolisten tcp";

    services.xserver.modules =
      concatLists (catAttrs "modules" cfg.drivers) ++
      [ xorg.xorgserver
        xorg.xf86inputevdev
      ];

    services.xserver.xkbDir = mkDefault "${pkgs.xkeyboard_config}/etc/X11/xkb";

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

        Section "InputClass"
          Identifier "Keyboard catchall"
          MatchIsKeyboard "on"
          Option "XkbRules" "base"
          Option "XkbModel" "${cfg.xkbModel}"
          Option "XkbLayout" "${cfg.layout}"
          Option "XkbOptions" "${cfg.xkbOptions}"
          Option "XkbVariant" "${cfg.xkbVariant}"
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

  };

}
