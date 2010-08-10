{ config, pkgs, pkgs_i686, ... }:

with pkgs.lib;

let

  kernelPackages = config.boot.kernelPackages;

  # Abbreviations.
  cfg = config.services.xserver;
  xorg = pkgs.xorg;


  # Map video driver names to driver packages.
  knownVideoDrivers = {
    ati          = { modules = [ xorg.xf86videoati ]; };
    ati_unfree   = { modules = [ kernelPackages.ati_drivers_x11 ]; driverName = "fglrx"; };
    cirrus       = { modules = [ xorg.xf86videocirrus ]; };
    i810         = { modules = [ xorg.xf86videoi810 ]; };
    intel        = { modules = [ xorg.xf86videointel ]; };
    nv           = { modules = [ xorg.xf86videonv ]; };
    nvidia       = { modules = [ kernelPackages.nvidia_x11 ]; };
    nvidiaLegacy = { modules = [ kernelPackages.nvidia_x11_legacy ]; driverName = "nvidia"; };
    openchrome   = { modules = [ xorg.xf86videoopenchrome ]; };
    sis          = { modules = [ xorg.xf86videosis ]; };
    unichrome    = { modules = [ pkgs.xorgVideoUnichrome ]; };
    vesa         = { modules = [ xorg.xf86videovesa ]; };
    virtualbox   = { modules = [ kernelPackages.virtualboxGuestAdditions ]; driverName = "vboxvideo"; };
    vmware       = { modules = [ xorg.xf86videovmware ]; };
  };

  driverNames =
    optional (cfg.videoDriver != null) cfg.videoDriver ++ cfg.videoDrivers;

  drivers = flip map driverNames
    (name: { inherit name; driverName = name; } //
      attrByPath [name] (throw "unknown video driver `${name}'") knownVideoDrivers);


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
        default = false;
        description = ''
          Whether to enable the X server.
        '';
      };

      autorun = mkOption {
        default = true;
        description = ''
          Whether to start the X server automatically.
        '';
      };

      exportConfiguration = mkOption {
        default = false;
        description = ''
          Whether to symlink the X server configuration under
          <filename>/etc/X11/xorg.conf</filename>.
        '';
      };

      enableTCP = mkOption {
        default = false;
        description = ''
          Whether to allow the X server to accept TCP connections.
        '';
      };

      modules = mkOption {
        default = [];
        example = [ pkgs.xf86_input_wacom ];
        description = "Packages to be added to the module search path of the X server.";
      };

      resolutions = mkOption {
        default = [];
        example = [ { x = 1600; y = 1200; } { x = 1024; y = 786; } ];
        description = ''
          The screen resolutions for the X server.  The first element
          is the default resolution.  If this list is empty, the X
          server will automatically configure the resolution.
        '';
      };

      videoDriver = mkOption {
        default = null;
        example = "i810";
        description = ''
          The name of the video driver for your graphics card.  This
          option is obsolete; please set the
          <option>videoDrivers</option> instead.
        '';
      };

      videoDrivers = mkOption {
        # !!! We'd like "nv" here, but it segfaults the X server.  Idem for
        # "vmware".
        default = [ "ati" "cirrus" "intel" "vesa" ];
        example = [ "vesa" ];
        description = ''
          The names of the video drivers that the X server should
          support.  The X server will try all of the drivers listed
          here until it finds one that supports your video card.
        '';
      };

      driSupport = mkOption {
        default = true;
        description = ''
          Whether to enable accelerated OpenGL rendering through the
          Direct Rendering Interface (DRI).
        '';
      };

      driSupport32Bit = mkOption {
        default = false;
        description = ''
          On 64-bit systems, whether to support Direct Rendering for
          32-bit applications (such as Wine).  This is currently only
          supported for the <literal>nvidia</literal> driver.
        '';
      };

      startOpenSSHAgent = mkOption {
        default = true;
        description = ''
          Whether to start the OpenSSH agent when you log in.  The OpenSSH agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection.  Use
          <command>ssh-add</command> to add a key to the agent.
        '';
      };

      startGnuPGAgent = mkOption {
        default = false;
        description = ''
          Whether to start the GnuPG agent when you log in.  The GnuPG agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection or sign/encrypt
          data.  Use <command>ssh-add</command> to add a key to the agent.
        '';
      };

      layout = mkOption {
        default = "us";
        description = ''
          Keyboard layout.
        '';
      };

      xkbModel = mkOption {
        default = "pc104";
        example = "presario";
        description = ''
          Keyboard model.
        '';
      };

      xkbOptions = mkOption {
        default = "terminate:ctrl_alt_bksp";
        example = "grp:caps_toggle, grp_led:scroll";
        description = ''
          X keyboard options; layout switching goes here.
        '';
      };

      config = mkOption {
        description = ''
          The contents of the configuration file of the X server
          (<filename>xorg.conf</filename>).
        '';
      };

      deviceSection = mkOption {
        default = "";
        example = "VideoRAM 131072";
        description = "Contents of the first Device section of the X server configuration file.";
      };

      screenSection = mkOption {
        default = "";
        example = ''
          Option "RandRRotation" "on"
        '';
        description = "Contents of the first Screen section of the X server configuration file.";
      };

      monitorSection = mkOption {
        default = "";
        example = "HorizSync 28-49";
        description = "Contents of the first Monitor section of the X server configuration file.";
      };

      moduleSection = mkOption {
        default = "";
        example =
          ''
            SubSection "extmod"
            EndSubsection
          '';
        description = "Contents of the Module section of the X server configuration file.";
      };

      serverLayoutSection = mkOption {
        default = "";
        example =
          ''
            Option "AIGLX" "true"
          '';
        description = "Contents of the ServerLayout section of the X server configuration file.";
      };

      extraDisplaySettings = mkOption {
        default = "";
        example = "Virtual 2048 2048";
        description = "Lines to be added to every Display subsection of the Screen section.";
      };

      defaultDepth = mkOption {
        default = 0;
        example = 8;
        description = "Default colour depth.";
      };

      useXFS = mkOption {
        default = false;
        example = "unix/:7100";
        description = "Determines how to connect to the X Font Server.";
      };

      tty = mkOption {
        default = 7;
        example = 9;
        description = "Virtual console for the X server.";
      };

      display = mkOption {
        default = 0;
        example = 1;
        description = "Display number for the X server.";
      };

      virtualScreen = mkOption {
        default = null;
        example = { x = 2048; y = 2048; };
        description = ''
          Virtual screen size for Xrandr.
        '';
      };
      
    };

    environment.x11Packages = mkOption {
      default = [];
      type = types.list types.package;
      description = ''
        List of packages added to the system when the X server is
        activated (<option>services.xserver.enable</option>).
      '';
    };
    
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions =
      [ { assertion = config.services.hal.enable == true;
          message = "The X server needs HAL running. Set services.hal.enable to true";
        }

        { assertion = if cfg.startOpenSSHAgent
                      then !cfg.startGnuPGAgent
                      else (if cfg.startGnuPGAgent
                            then !cfg.startOpenSSHAgent
                            else true);
          message =
            "The OpenSSH agent and GnuPG agent cannot be started both.  " +
            "Choose between `startOpenSSHAgent' and `startGnuPGAgent'.";
        }
      ];

    boot.extraModulePackages =
      optional (elem "nvidia" driverNames) kernelPackages.nvidia_x11 ++ 
      optional (elem "nvidiaLegacy" driverNames) kernelPackages.nvidia_x11_legacy ++
      optional (elem "virtualbox" driverNames) kernelPackages.virtualboxGuestAdditions ++
      optional (elem "ati_unfree" driverNames) kernelPackages.ati_drivers_x11;

    environment.etc = optionals cfg.exportConfiguration
      [ { source = "${configFile}";
          target = "X11/xorg.conf";
        }
        # -xkbdir command line option does not seems to be passed to xkbcomp.
        { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
          target = "X11/xkb";
        }
      ];
    
    environment.x11Packages =
      [ xorg.xorgserver
        xorg.xrandr
        xorg.xrdb
        xorg.setxkbmap
        xorg.iceauth # required for KDE applications (it's called by dcopserver)
        xorg.xlsclients
        xorg.xset
        xorg.xsetroot
        xorg.xprop
        pkgs.xterm
      ]
      ++ optional (elem "nvidia" driverNames) kernelPackages.nvidia_x11
      ++ optional (elem "nvidiaLegacy" driverNames) kernelPackages.nvidia_x11_legacy
      ++ optional (elem "virtualbox" driverNames) xorg.xrefresh
      ++ optional (elem "ati_unfree" driverNames) kernelPackages.ati_drivers_x11;
      
    environment.systemPackages = config.environment.x11Packages;

    environment.pathsToLink =
      [ "/etc/xdg" "/share/xdg" "/share/applications" "/share/icons" "/share/pixmaps" ];
        
    services.hal.packages = optional (elem "virtualbox" driverNames) kernelPackages.virtualboxGuestAdditions;

    jobs.xserver =
      { startOn = if cfg.autorun then "filesystem and stopped udevtrigger and started hal" else "";
 
        environment =
          { FONTCONFIG_FILE = "/etc/fonts/fonts.conf"; # !!! cleanup
            XKB_BINDIR = "${xorg.xkbcomp}/bin"; # Needed for the Xkb extension.
            TZ = config.time.timeZone;
          } # !!! Depends on the driver selected at runtime.
            // optionalAttrs (!elem "nvidia" driverNames) {
            XORG_DRI_DRIVER_PATH = "${pkgs.mesa}/lib/dri";
          } // optionalAttrs (elem "nvidia" driverNames) {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11}/lib";
          } // optionalAttrs (elem "nvidiaLegacy" driverNames) {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11_legacy}/lib";
          } // optionalAttrs (elem "ati_unfree" driverNames) {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.ati_drivers_x11}/lib:${kernelPackages.ati_drivers_x11}/X11R6/lib64/modules/linux";
            XORG_DRI_DRIVER_PATH = "${kernelPackages.ati_drivers_x11}/lib/dri"; # is ignored because ati drivers ship their own unpatched libglx.so !
          } // cfg.displayManager.job.environment;

        preStart =
          ''
            rm -f /var/run/opengl-driver
            ${# !!! The OpenGL driver depends on what's detected at runtime.
              if elem "nvidia" driverNames then
                ''
                  ln -sf ${kernelPackages.nvidia_x11} /var/run/opengl-driver
                  ${optionalString (pkgs.stdenv.system == "x86_64-linux" && cfg.driSupport32Bit)
                    "ln -sf ${pkgs_i686.linuxPackages.nvidia_x11.override { libsOnly = true; kernel = null; } } /var/run/opengl-driver-32"}
                ''
              else if elem "nvidiaLegacy" driverNames then
                "ln -sf ${kernelPackages.nvidia_x11_legacy} /var/run/opengl-driver"
              else if cfg.driSupport then
                "ln -sf ${pkgs.mesa} /var/run/opengl-driver"
              else ""
            }

            ${cfg.displayManager.job.preStart}

            rm -f /tmp/.X0-lock
          '';

        script = "${cfg.displayManager.job.execCmd}";
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
            ${optionalString (driver.name == "nvidiaLegacy") ''
              # This option allows suspending with a nvidiaLegacy card
              Option "NvAGP" "1"
            ''}
            ${cfg.deviceSection}
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
      '';

  };

}
