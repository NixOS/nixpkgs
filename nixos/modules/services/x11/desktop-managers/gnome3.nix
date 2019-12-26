{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.gnome3;
  serviceCfg = config.services.gnome3;

  # Prioritize nautilus by default when opening directories
  mimeAppsList = pkgs.writeTextFile {
    name = "gnome-mimeapps";
    destination = "/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };

  nixos-gsettings-desktop-schemas = let
    defaultPackages = with pkgs; [ gsettings-desktop-schemas gnome3.gnome-shell ];
  in
  pkgs.runCommand "nixos-gsettings-desktop-schemas" { preferLocalBuild = true; }
    ''
     mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     ${concatMapStrings
        (pkg: "cp -rf ${pkg}/share/gsettings-schemas/*/glib-2.0/schemas/*.xml $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas\n")
        (defaultPackages ++ cfg.extraGSettingsOverridePackages)}

     cp -f ${pkgs.gnome3.gnome-shell}/share/gsettings-schemas/*/glib-2.0/schemas/*.gschema.override $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     ${optionalString flashbackEnabled ''
       cp -f ${pkgs.gnome3.gnome-flashback}/share/gsettings-schemas/*/glib-2.0/schemas/*.gschema.override $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
     ''}

     chmod -R a+w $out/share/gsettings-schemas/nixos-gsettings-overrides
     cat - > $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/nixos-defaults.gschema.override <<- EOF
       [org.gnome.desktop.background]
       picture-uri='file://${pkgs.nixos-artwork.wallpapers.simple-dark-gray}/share/artwork/gnome/nix-wallpaper-simple-dark-gray.png'

       [org.gnome.desktop.screensaver]
       picture-uri='file://${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom}/share/artwork/gnome/nix-wallpaper-simple-dark-gray_bottom.png'

       [org.gnome.shell]
       favorite-apps=[ 'org.gnome.Epiphany.desktop', 'org.gnome.Geary.desktop', 'org.gnome.Music.desktop', 'org.gnome.Photos.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Software.desktop' ]

       ${cfg.extraGSettingsOverrides}
     EOF

     ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    '';

  flashbackEnabled = cfg.flashback.enableMetacity || length cfg.flashback.customSessions > 0;

in

{

  options = {

    services.gnome3 = {
      core-os-services.enable = mkEnableOption "essential services for GNOME3";
      core-shell.enable = mkEnableOption "GNOME Shell services";
      core-utilities.enable = mkEnableOption "GNOME core utilities";
      games.enable = mkEnableOption "GNOME games";
    };

    services.xserver.desktopManager.gnome3 = {
      enable = mkOption {
        default = false;
        description = "Enable Gnome 3 desktop manager.";
      };

      sessionPath = mkOption {
        default = [];
        example = literalExample "[ pkgs.gnome3.gpaste ]";
        description = ''
          Additional list of packages to be added to the session search path.
          Useful for GNOME Shell extensions or GSettings-conditional autostart.

          Note that this should be a last resort; patching the package is preferred (see GPaste).
        '';
        apply = list: list ++ [ pkgs.gnome3.gnome-shell pkgs.gnome3.gnome-shell-extensions ];
      };

      extraGSettingsOverrides = mkOption {
        default = "";
        type = types.lines;
        description = "Additional gsettings overrides.";
      };

      extraGSettingsOverridePackages = mkOption {
        default = [];
        type = types.listOf types.path;
        description = "List of packages for which gsettings are overridden.";
      };

      debug = mkEnableOption "gnome-session debug messages";

      flashback = {
        enableMetacity = mkEnableOption "the standard GNOME Flashback session with Metacity";

        customSessions = mkOption {
          type = types.listOf (types.submodule {
            options = {
              wmName = mkOption {
                type = types.str;
                description = "The filename-compatible name of the window manager to use.";
                example = "xmonad";
              };

              wmLabel = mkOption {
                type = types.str;
                description = "The pretty name of the window manager to use.";
                example = "XMonad";
              };

              wmCommand = mkOption {
                type = types.str;
                description = "The executable of the window manager to use.";
                example = "\${pkgs.haskellPackages.xmonad}/bin/xmonad";
              };
            };
          });
          default = [];
          description = "Other GNOME Flashback sessions to enable.";
        };
      };
    };

    environment.gnome3.excludePackages = mkOption {
      default = [];
      example = literalExample "[ pkgs.gnome3.totem ]";
      type = types.listOf types.package;
      description = "Which packages gnome should exclude from the default environment";
    };

  };

  config = mkMerge [
    (mkIf (cfg.enable || flashbackEnabled) {
      services.gnome3.core-os-services.enable = true;
      services.gnome3.core-shell.enable = true;
      services.gnome3.core-utilities.enable = mkDefault true;

      services.xserver.displayManager.sessionPackages = [ pkgs.gnome3.gnome-session ];

      environment.extraInit = ''
        ${concatMapStrings (p: ''
          if [ -d "${p}/share/gsettings-schemas/${p.name}" ]; then
            export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${p}/share/gsettings-schemas/${p.name}
          fi

          if [ -d "${p}/lib/girepository-1.0" ]; then
            export GI_TYPELIB_PATH=$GI_TYPELIB_PATH''${GI_TYPELIB_PATH:+:}${p}/lib/girepository-1.0
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${p}/lib
          fi
        '') cfg.sessionPath}
      '';

      environment.systemPackages = cfg.sessionPath;

      environment.sessionVariables.GNOME_SESSION_DEBUG = mkIf cfg.debug "1";

      # Override GSettings schemas
      environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";

       # If gnome3 is installed, build vim for gtk3 too.
      nixpkgs.config.vim.gui = "gtk3";
    })

    (mkIf flashbackEnabled {
      services.xserver.displayManager.sessionPackages =  map
        (wm: pkgs.gnome3.gnome-flashback.mkSessionForWm {
          inherit (wm) wmName wmLabel wmCommand;
        }) (optional cfg.flashback.enableMetacity {
              wmName = "metacity";
              wmLabel = "Metacity";
              wmCommand = "${pkgs.gnome3.metacity}/bin/metacity";
            } ++ cfg.flashback.customSessions);

      security.pam.services.gnome-screensaver = {
        enableGnomeKeyring = true;
      };

      systemd.packages = with pkgs.gnome3; [
        gnome-flashback
      ] ++ (map
        (wm: gnome-flashback.mkSystemdTargetForWm {
          inherit (wm) wmName;
        }) cfg.flashback.customSessions);

      services.dbus.packages = [
        pkgs.gnome3.gnome-screensaver
      ];
    })

    (mkIf serviceCfg.core-os-services.enable {
      hardware.bluetooth.enable = mkDefault true;
      hardware.pulseaudio.enable = mkDefault true;
      programs.dconf.enable = true;
      security.polkit.enable = true;
      services.accounts-daemon.enable = true;
      services.dleyna-renderer.enable = mkDefault true;
      services.dleyna-server.enable = mkDefault true;
      services.gnome3.at-spi2-core.enable = true;
      services.gnome3.evolution-data-server.enable = true;
      services.gnome3.gnome-keyring.enable = true;
      services.gnome3.gnome-online-accounts.enable = mkDefault true;
      services.gnome3.gnome-online-miners.enable = true;
      services.gnome3.tracker-miners.enable = mkDefault true;
      services.gnome3.tracker.enable = mkDefault true;
      services.hardware.bolt.enable = mkDefault true;
      services.packagekit.enable = mkDefault true;
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.xserver.libinput.enable = mkDefault true; # for controlling touchpad settings via gnome control center

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      networking.networkmanager.enable = mkDefault true;

      services.xserver.updateDbusEnvironment = true;

      # gnome has a custom alert theme but it still
      # inherits from the freedesktop theme.
      environment.systemPackages = with pkgs; [
        sound-theme-freedesktop
      ];

      # Needed for themes and backgrounds
      environment.pathsToLink = [
        "/share" # TODO: https://github.com/NixOS/nixpkgs/issues/47173
      ];
    })

    (mkIf serviceCfg.core-shell.enable {
      services.colord.enable = mkDefault true;
      services.gnome3.chrome-gnome-shell.enable = mkDefault true;
      services.gnome3.glib-networking.enable = true;
      services.gnome3.gnome-initial-setup.enable = mkDefault true;
      services.gnome3.gnome-remote-desktop.enable = mkDefault true;
      services.gnome3.gnome-settings-daemon.enable = true;
      services.gnome3.gnome-user-share.enable = mkDefault true;
      services.gnome3.rygel.enable = mkDefault true;
      services.gvfs.enable = true;
      services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
      services.telepathy.enable = mkDefault true;

      systemd.packages = with pkgs.gnome3; [ vino gnome-session ];

      services.avahi.enable = mkDefault true;

      xdg.portal.extraPortals = [ pkgs.gnome3.gnome-shell ];

      services.geoclue2.enable = mkDefault true;
      services.geoclue2.enableDemoAgent = false; # GNOME has its own geoclue agent

      services.geoclue2.appConfig.gnome-datetime-panel = {
        isAllowed = true;
        isSystem = true;
      };
      services.geoclue2.appConfig.gnome-color-panel = {
        isAllowed = true;
        isSystem = true;
      };
      services.geoclue2.appConfig."org.gnome.Shell" = {
        isAllowed = true;
        isSystem = true;
      };

      fonts.fonts = with pkgs; [
        cantarell-fonts
        dejavu_fonts
        source-code-pro # Default monospace font in 3.32
        source-sans-pro
      ];

      ## Enable soft realtime scheduling, only supported on wayland ##

      security.wrappers.".gnome-shell-wrapped" = {
        source = "${pkgs.gnome3.gnome-shell}/bin/.gnome-shell-wrapped";
        capabilities = "cap_sys_nice=ep";
      };

      systemd.user.services.gnome-shell-wayland = let
        gnomeShellRT = with pkgs.gnome3; pkgs.runCommand "gnome-shell-rt" {} ''
          mkdir -p $out/bin/
          cp ${gnome-shell}/bin/gnome-shell $out/bin
          sed -i "s@${gnome-shell}/bin/@${config.security.wrapperDir}/@" $out/bin/gnome-shell
        '';
      in {
        # Note we need to clear ExecStart before overriding it
        serviceConfig.ExecStart = ["" "${gnomeShellRT}/bin/gnome-shell"];
        # Do not use the default environment, it provides a broken PATH
        environment = mkForce {};
      };

      # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-32/elements/core/meta-gnome-core-shell.bst
      environment.systemPackages = with pkgs.gnome3; [
        adwaita-icon-theme
        gnome-backgrounds
        gnome-bluetooth
        gnome-color-manager
        gnome-control-center
        gnome-getting-started-docs
        gnome-shell
        gnome-shell-extensions
        gnome-themes-extra
        pkgs.gnome-user-docs
        pkgs.orca
        pkgs.glib # for gsettings
        pkgs.gnome-menus
        pkgs.gtk3.out # for gtk-launch
        pkgs.hicolor-icon-theme
        pkgs.shared-mime-info # for update-mime-database
        pkgs.xdg-user-dirs # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
        vino
      ];
    })

    # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-32/elements/core/meta-gnome-core-utilities.bst
    (mkIf serviceCfg.core-utilities.enable {
      environment.systemPackages = (with pkgs.gnome3; removePackagesByName [
        baobab
        cheese
        eog
        epiphany
        geary
        gedit
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-clocks
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        gnome-photos
        gnome-screenshot
        gnome-software
        gnome-system-monitor
        gnome-weather
        nautilus
        simple-scan
        totem
        yelp
        # Unsure if sensible for NixOS
        /* gnome-boxes */
      ] config.environment.gnome3.excludePackages);

      # Enable default programs
      programs.evince.enable = mkDefault true;
      programs.file-roller.enable = mkDefault true;
      programs.gnome-disks.enable = mkDefault true;
      programs.gnome-terminal.enable = mkDefault true;
      programs.seahorse.enable = mkDefault true;
      services.gnome3.sushi.enable = mkDefault true;

      # Let nautilus find extensions
      # TODO: Create nautilus-with-extensions package
      environment.sessionVariables.NAUTILUS_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-3.0";

      # Override default mimeapps for nautilus
      environment.sessionVariables.XDG_DATA_DIRS = [ "${mimeAppsList}/share" ];

      environment.pathsToLink = [
        "/share/nautilus-python/extensions"
      ];
    })

    (mkIf serviceCfg.games.enable {
      environment.systemPackages = (with pkgs.gnome3; removePackagesByName [
        aisleriot atomix five-or-more four-in-a-row gnome-chess gnome-klotski
        gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku
        gnome-taquin gnome-tetravex hitori iagno lightsoff quadrapassel
        swell-foop tali
      ] config.environment.gnome3.excludePackages);
    })
  ];

}
