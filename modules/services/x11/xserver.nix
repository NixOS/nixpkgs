{ config, pkgs, ... }:

with pkgs.lib;

let

  kernelPackages = config.boot.kernelPackages;

  # Abbreviations.
  cfg = config.services.xserver;
  xorg = pkgs.xorg;


  # Map the video driver setting to a driver.
  knownVideoDrivers = {
    nvidia =     { modules = [ kernelPackages.nvidia_x11 ]; };
    nvidiaLegacy =     { modules = [ kernelPackages.nvidia_x11_legacy ]; };
    vesa =       { modules = [ xorg.xf86videovesa ]; };
    vga =        { modules = [ xorg.xf86videovga ]; };
    sis =        { modules = [ xorg.xf86videosis ]; };
    i810 =       { modules = [ xorg.xf86videoi810 ]; };
    intel =      { modules = [ xorg.xf86videointel ]; };
    nv =         { modules = [ xorg.xf86videonv ]; };
    ati =        { modules = [ xorg.xf86videoati ]; };
    openchrome = { modules = [ xorg.xf86videoopenchrome ]; };
    unichrome  = { modules = [ pkgs.xorgVideoUnichrome ]; };
    cirrus =     { modules = [ xorg.xf86videocirrus ]; };
    vmware =     { modules = [ xorg.xf86videovmware ]; };
    virtualbox = { modules = [ kernelPackages.virtualboxGuestAdditions ]; };
  };

  videoDriver = cfg.videoDriver;

  videoDriverInfo = attrByPath [videoDriver] (throw "unknown video driver: `${videoDriver}'") knownVideoDrivers;


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


  halConfigFiles = singleton (pkgs.writeTextFile
    { name = "hal-policy-keymap";
      destination = "/share/hal/fdi/policy/30-keymap.fdi";
      text =
        ''
          <?xml version="1.0" encoding="ISO-8859-1"?>
          <deviceinfo version="0.2">
            <device>
              <match key="info.capabilities" contains="input.keymap">
                <append key="info.callouts.add" type="strlist">hal-setup-keymap</append>
              </match>

              <match key="info.capabilities" contains="input.keys">
                <merge key="input.x11_options.XkbRules" type="string">base</merge>
                <merge key="input.x11_options.XkbModel" type="string">${cfg.xkbModel}</merge>
                <merge key="input.x11_options.XkbLayout" type="string">${cfg.layout}</merge>
                <append key="input.x11_options.XkbOptions" type="strlist">${cfg.xkbOptions}</append>
              </match>
            </device>
          </deviceinfo>
        '';
    });

  
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
        example = [ pkgs.linuxwacom ];
        description = "Packages to be added to the module search path of the X server.";
      };

      resolutions = mkOption {
        default = [ {x = 1024; y = 768;} {x = 800; y = 600;} {x = 640; y = 480;} ];
        description = ''
          The screen resolutions for the X server.  The first element is the default resolution.
        '';
      };

      videoDriver = mkOption {
        default = "vesa";
        example = "i810";
        description = ''
          The name of the video driver for your graphics card.
        '';
      };

      driSupport = mkOption {
        default = true;
        description = ''
          Whether to enable accelerated OpenGL rendering through the
          Direct Rendering Interface (DRI).
        '';
      };

      startSSHAgent = mkOption {
        default = true;
        description = ''
          Whether to start the SSH agent when you log in.  The SSH agent
          remembers private keys for you so that you don't have to type in
          passphrases every time you make an SSH connection.  Use
          <command>ssh-add</command> to add a key to the agent.
        '';
      };

      isClone = mkOption {
        default = true;
        example = false;
        description = ''
          Whether to enable the X server clone mode for dual-head.
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
        default = "";
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
        default = 24;
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

    assertions = singleton
      { assertion = config.services.hal.enable == true;
        message = "The X server needs HAL running. Set services.hal.enable to true";
      };

    boot.extraModulePackages =
      optional (cfg.videoDriver == "nvidia") kernelPackages.nvidia_x11 ++ 
      optional (cfg.videoDriver == "nvidiaLegacy") kernelPackages.nvidia_x11_legacy ++
      optional (cfg.videoDriver == "virtualbox") kernelPackages.virtualboxGuestAdditions;

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
        xorg.xsetroot
        xorg.xprop
      ]
      ++ optional (videoDriver == "nvidia") kernelPackages.nvidia_x11
      ++ optional (videoDriver == "nvidiaLegacy") kernelPackages.nvidia_x11_legacy;
      
    environment.systemPackages = config.environment.x11Packages;
    
    services.hal.packages = halConfigFiles ++
      optional (videoDriver == "virtualbox") kernelPackages.virtualboxGuestAdditions;

    jobs.xserver =
      { startOn = if cfg.autorun then "hal" else "never";
 
        environment =
          { FONTCONFIG_FILE = "/etc/fonts/fonts.conf"; # !!! cleanup
            XKB_BINDIR = "${xorg.xkbcomp}/bin"; # Needed for the Xkb extension.
          } // optionalAttrs (videoDriver != "nvidia") {
            XORG_DRI_DRIVER_PATH = "${pkgs.mesa}/lib/dri";
          } // optionalAttrs (videoDriver == "nvidia") {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11}/lib";
          } // optionalAttrs (videoDriver == "nvidiaLegacy") {
            LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXext}/lib:${kernelPackages.nvidia_x11_legacy}/lib";
          } // cfg.displayManager.job.environment;

        preStart =
          ''
            # Ugly hack: wait until udev has started since the X server
            # needs various devices.  This would more properly be
            # expressed as an Upstart dependency, but AFAIK in "start
            # on" we can't express a logical AND.
            while ! initctl status udev 2>&1 | grep -q running; do
                sleep 1
            done
        
            rm -f /var/run/opengl-driver
            ${if videoDriver == "nvidia"
              then ''
                ln -sf ${kernelPackages.nvidia_x11} /var/run/opengl-driver
              ''
	      else if videoDriver == "nvidiaLegacy"
              then ''
                ln -sf ${kernelPackages.nvidia_x11_legacy} /var/run/opengl-driver
              ''
              else if cfg.driSupport
              then "ln -sf ${pkgs.mesa} /var/run/opengl-driver"
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

    services.xserver.modules = videoDriverInfo.modules
      ++ [ xorg.xorgserver xorg.xf86inputevdev ];
    
    services.xserver.config =
      ''
        Section "ServerFlags"
          Option "AllowMouseOpenFail" "on"
        EndSection

        Section "Module"
          ${cfg.moduleSection}
        EndSection

        Section "Monitor"
          ${cfg.monitorSection}
        EndSection

        Section "Device"
          ${cfg.deviceSection}
        EndSection

        Section "ServerLayout"
          ${cfg.serverLayoutSection}
        EndSection

        Section "Screen"
          Identifier "Screen[0]"
          Device "Device[0]"
          Monitor "Monitor[0]"

          ${optionalString (cfg.defaultDepth != 0) ''
            DefaultDepth ${toString cfg.defaultDepth}
          ''}

          ${optionalString (cfg.videoDriver == "nvidia") ''
            Option "RandRRotation" "on"
          ''}

          ${if cfg.videoDriver != "virtualbox" then
            let
              f = depth:
                ''
                  SubSection "Display"
                    Depth ${toString depth}
                    Modes ${concatMapStrings (res: ''"${toString res.x}x${toString res.y}"'') cfg.resolutions}
                    ${cfg.extraDisplaySettings}
                    ${optionalString (cfg.virtualScreen != null)
                      "Virtual ${toString cfg.virtualScreen.x} ${toString cfg.virtualScreen.y}"}
                  EndSubSection
                '';
            in concatMapStrings f [8 16 24]
	    else
	      "" # The VirtualBox driver does not support dynamic resizing if resolutions are defined
          }

        EndSection

        Section "Extensions"
          ${optionalString (cfg.videoDriver == "nvidia" || cfg.videoDriver == "nvidiaLegacy" || cfg.videoDriver == "i810" || cfg.videoDriver == "ati" || cfg.videoDriver == "radeonhd") ''
            Option "Composite" "Enable"
          ''}
        EndSection

        Section "DRI"
          Mode 0666 # !!! FIX THIS!
        EndSection
      '';

    services.xserver.monitorSection =
      ''
        Identifier "Monitor[0]"
      '';
      
    services.xserver.deviceSection =
      ''
        Identifier "Device[0]"
        Driver "${if cfg.videoDriver == "nvidiaLegacy" then "nvidia" 
	          else if cfg.videoDriver == "virtualbox" then "vboxvideo"
	          else cfg.videoDriver}"

        ${if cfg.videoDriver == "nvidiaLegacy" then ''
        # This option allows suspending with a nvidiaLegacy card
	Option "NvAGP" "1"''
        else ""}
        # !!! Is the "Clone" option still useful?
        Option "Clone" "${if cfg.isClone then "on" else "off"}"
      '';

    services.xserver.serverLayoutSection =
      ''
        Identifier "Layout[all]"
        Screen "Screen[0]"
      '';

  };

}
