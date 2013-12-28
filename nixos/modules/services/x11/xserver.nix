{ config, pkgs, pkgs_i686, ... }:

with pkgs.lib;

let

  kernelPackages = config.boot.kernelPackages;

  # Abbreviations.
  cfg = config.services.xserver;
  xorg = pkgs.xorg;


  # Map video driver names to driver packages.
  knownVideoDrivers = {
    ati_unfree   = { modules = [ kernelPackages.ati_drivers_x11 ]; driverName = "fglrx"; };
    nouveau       = { modules = [ pkgs.xf86_video_nouveau ]; };
    nvidia       = { modules = [ kernelPackages.nvidia_x11 ]; };
    nvidiaLegacy96 = { modules = [ kernelPackages.nvidia_x11_legacy96 ]; driverName = "nvidia"; };
    nvidiaLegacy173 = { modules = [ kernelPackages.nvidia_x11_legacy173 ]; driverName = "nvidia"; };
    nvidiaLegacy304 = { modules = [ kernelPackages.nvidia_x11_legacy304 ]; driverName = "nvidia"; };
    unichrome    = { modules = [ pkgs.xorgVideoUnichrome ]; };
    virtualbox   = { modules = [ kernelPackages.virtualboxGuestAdditions ]; driverName = "vboxvideo"; };
  };

  driverNames =
    optional (cfg.videoDriver != null) cfg.videoDriver ++ cfg.videoDrivers;

  drivers = flip map driverNames
    (name: { inherit name; driverName = name; } //
      attrByPath [name] (if (hasAttr ("xf86video" + name) xorg) then { modules = [(getAttr ("xf86video" + name) xorg) ]; } else throw "unknown video driver `${name}'") knownVideoDrivers);

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

  xrandrDeviceSection = flip concatMapStrings xrandrHeads (h: ''
    Option "monitor-${h.output}" "${h.name}"
  '');

  # Here we chain every monitor from the left to right, so we have:
  # m4 right of m3 right of m2 right of m1   .----.----.----.----.
  # Which will end up in reverse ----------> | m1 | m2 | m3 | m4 |
  #                                          `----^----^----^----'
  xrandrMonitorSections = let
    mkMonitor = previous: current: previous ++ singleton {
      inherit (current) name;
      value = ''
        Section "Monitor"
          Identifier "${current.name}"
          ${optionalString (previous != []) ''
          Option "RightOf" "${(head previous).name}"
          ''}
        EndSection
      '';
    };
    monitors = foldl mkMonitor [] xrandrHeads;
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

      modules = mkOption {
        type = types.listOf types.path;
        default = [];
        example = [ pkgs.xf86_input_wacom ];
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

      videoDriver = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "i810";
        description = ''
          The name of the video driver for your graphics card.  This
          option is obsolete; please set the
          <option>videoDrivers</option> instead.
        '';
      };

      videoDrivers = mkOption {
        type = types.listOf types.str;
        # !!! We'd like "nv" here, but it segfaults the X server.
        default = [ "ati" "cirrus" "intel" "vesa" "vmware" ];
        example = [ "vesa" ];
        description = ''
          The names of the video drivers that the X server should
          support.  The X server will try all of the drivers listed
          here until it finds one that supports your video card.
        '';
      };

      vaapiDrivers = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = "[ pkgs.vaapiIntel pkgs.vaapiVdpau ]";
        description = ''
          Packages providing libva acceleration drivers.
        '';
      };

      driSupport = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable accelerated OpenGL rendering through the
          Direct Rendering Interface (DRI).
        '';
      };

      driSupport32Bit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          On 64-bit systems, whether to support Direct Rendering for
          32-bit applications (such as Wine).  This is currently only
          supported for the <literal>nvidia</literal> driver and for
          <literal>mesa</literal>.
        '';
      };

      s3tcSupport = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Make S3TC(S3 Texture Compression) via libtxc_dxtn available
          to OpenGL drivers. It is essential for many games to work
          with FOSS GPU drivers.

          Using this library may require a patent license depending on your location.
        '';
      };

      startOpenSSHAgent = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to start the OpenSSH agent when you log in.  The OpenSSH agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection.  Use
          <command>ssh-add</command> to add a key to the agent.
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
        type = types.int;
        default = 7;
        description = "Virtual console for the X server.";
      };

      display = mkOption {
        type = types.int;
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

    };

  };



  ###### implementation

  config = mkIf cfg.enable {

    assertions =
      [ { assertion = !(cfg.startOpenSSHAgent && cfg.startGnuPGAgent);
          message =
            ''
              The OpenSSH agent and GnuPG agent cannot be started both.
              Choose between `startOpenSSHAgent' and `startGnuPGAgent'.
            '';
        }
        { assertion = config.security.polkit.enable;
          message = "X11 requires Polkit to be enabled (‘security.polkit.enable = true’).";
        }
      ];

    boot.extraModulePackages =
      optional (elem "nvidia" driverNames) kernelPackages.nvidia_x11 ++
      optional (elem "nvidiaLegacy96" driverNames) kernelPackages.nvidia_x11_legacy96 ++
      optional (elem "nvidiaLegacy173" driverNames) kernelPackages.nvidia_x11_legacy173 ++
      optional (elem "nvidiaLegacy304" driverNames) kernelPackages.nvidia_x11_legacy304 ++
      optional (elem "virtualbox" driverNames) kernelPackages.virtualboxGuestAdditions ++
      optional (elem "ati_unfree" driverNames) kernelPackages.ati_drivers_x11;

    boot.blacklistedKernelModules =
      optionals (elem "nvidia" driverNames) [ "nouveau" "nvidiafb" ];

    environment.variables.LD_LIBRARY_PATH =
      [ "/run/opengl-driver/lib" "/run/opengl-driver-32/lib" ]
      ++ pkgs.lib.optional cfg.s3tcSupport "${pkgs.libtxc_dxtn}/lib"
      ++ pkgs.lib.optional (cfg.s3tcSupport && cfg.driSupport32Bit) "${pkgs_i686.libtxc_dxtn}/lib";

    environment.etc =
      (optionals cfg.exportConfiguration
        [ { source = "${configFile}";
            target = "X11/xorg.conf";
          }
          # -xkbdir command line option does not seems to be passed to xkbcomp.
          { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
            target = "X11/xkb";
          }
        ])
      ++ (optionals (elem "ati_unfree" driverNames) [

          # according toiive on #ati you don't need the pcs, it is like registry... keeps old stuff to make your
          # life harder ;) Still it seems to be required
          { source = "${kernelPackages.ati_drivers_x11}/etc/ati";
            target = "ati";
          }
      ])
      ++ (optionals (elem "nvidia" driverNames) [

          { source = "${kernelPackages.nvidia_x11}/lib/vendors/nvidia.icd";
            target = "OpenCL/vendors/nvidia.icd";
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
      ++ optional (elem "nvidia" driverNames) kernelPackages.nvidia_x11
      ++ optional (elem "nvidiaLegacy96" driverNames) kernelPackages.nvidia_x11_legacy96
      ++ optional (elem "nvidiaLegacy173" driverNames) kernelPackages.nvidia_x11_legacy173
      ++ optional (elem "nvidiaLegacy304" driverNames) kernelPackages.nvidia_x11_legacy304
      ++ optional (elem "virtualbox" driverNames) xorg.xrefresh
      ++ optional (elem "ati_unfree" driverNames) kernelPackages.ati_drivers_x11;

    environment.pathsToLink =
      [ "/etc/xdg" "/share/xdg" "/share/applications" "/share/icons" "/share/pixmaps" ];

    systemd.defaultUnit = mkIf cfg.autorun "graphical.target";

    systemd.services."display-manager" =
      { description = "X11 Server";

        after = [ "systemd-udev-settle.service" "local-fs.target" ];

        restartIfChanged = false;

        environment =
          { FONTCONFIG_FILE = "/etc/fonts/fonts.conf"; # !!! cleanup
            XKB_BINDIR = "${xorg.xkbcomp}/bin"; # Needed for the Xkb extension.
            XORG_DRI_DRIVER_PATH = "/run/opengl-driver/lib/dri"; # !!! Depends on the driver selected at runtime.
          } // optionalAttrs (elem "nvidia" driverNames) {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11}/lib";
          } // optionalAttrs (elem "nvidiaLegacy96" driverNames) {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11_legacy96}/lib";
          } // optionalAttrs (elem "nvidiaLegacy173" driverNames) {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11_legacy173}/lib";
          } // optionalAttrs (elem "nvidiaLegacy304" driverNames) {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11_legacy304}/lib";
          } // optionalAttrs (elem "ati_unfree" driverNames) {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.ati_drivers_x11}/lib:${kernelPackages.ati_drivers_x11}/X11R6/lib64/modules/linux";
            #XORG_DRI_DRIVER_PATH = "${kernelPackages.ati_drivers_x11}/lib/dri"; # is ignored because ati drivers ship their own unpatched libglx.so !
          } // cfg.displayManager.job.environment;

        preStart =
          ''
            rm -f /run/opengl-driver{,-32}
            ${optionalString (!cfg.driSupport32Bit) "ln -sf opengl-driver /run/opengl-driver-32"}

            ${# !!! The OpenGL driver depends on what's detected at runtime.
              if elem "nvidia" driverNames then
                ''
                  ln -sf ${kernelPackages.nvidia_x11} /run/opengl-driver
                  ${optionalString cfg.driSupport32Bit
                    "ln -sf ${pkgs_i686.linuxPackages.nvidia_x11.override { libsOnly = true; kernelDev = null; } } /run/opengl-driver-32"}
                ''
              else if elem "nvidiaLegacy96" driverNames then
                "ln -sf ${kernelPackages.nvidia_x11_legacy96} /run/opengl-driver"
              else if elem "nvidiaLegacy173" driverNames then
                "ln -sf ${kernelPackages.nvidia_x11_legacy173} /run/opengl-driver"
              else if elem "nvidiaLegacy304" driverNames then
                ''
                  ln -sf ${kernelPackages.nvidia_x11_legacy304} /run/opengl-driver
                  ${optionalString cfg.driSupport32Bit
                    "ln -sf ${pkgs_i686.linuxPackages.nvidia_x11_legacy304.override { libsOnly = true; kernelDev = null; } } /run/opengl-driver-32"}
                ''
              else if elem "ati_unfree" driverNames then
                "ln -sf ${kernelPackages.ati_drivers_x11} /run/opengl-driver"
              else
                ''
                  ${optionalString cfg.driSupport "ln -sf ${pkgs.mesa_drivers} /run/opengl-driver"}
                  ${optionalString cfg.driSupport32Bit
                    "ln -sf ${pkgs_i686.mesa_drivers} /run/opengl-driver-32"}
                ''
            }

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
      [ "-ac"
        "-logverbose"
        "-verbose"
        "-terminate"
        "-logfile" "/var/log/X.${toString cfg.display}.log"
        "-config ${configFile}"
        ":${toString cfg.display}" "vt${toString cfg.tty}"
        "-xkbdir" "${pkgs.xkeyboard_config}/etc/X11/xkb"
      ] ++ optional (!cfg.enableTCP) "-nolisten tcp";

    services.xserver.modules =
      concatLists (catAttrs "modules" drivers) ++
      [ xorg.xorgserver
        xorg.xf86inputevdev
      ];

    services.xserver.config =
      ''
        Section "ServerFlags"
          Option "AllowMouseOpenFail" "on"
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

        Section "ServerLayout"
          Identifier "Layout[all]"
          ${cfg.serverLayoutSection}
          # Reference the Screen sections for each driver.  This will
          # cause the X server to try each in turn.
          ${flip concatMapStrings drivers (d: ''
            Screen "Screen-${d.name}[0]"
          '')}
        EndSection

        # For each supported driver, add a "Device" and "Screen"
        # section.
        ${flip concatMapStrings drivers (driver: ''

          Section "Device"
            Identifier "Device-${driver.name}[0]"
            Driver "${driver.driverName}"
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

            ${optionalString (driver.name == "nvidia") ''
              Option "RandRRotation" "on"
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

