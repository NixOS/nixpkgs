{ config, lib, pkgs, utils, ... }:

with lib;

let

  cfg = config.services.xserver.desktopManager.gnome;
  serviceCfg = config.services.gnome;

  # Prioritize nautilus by default when opening directories
  mimeAppsList = pkgs.writeTextFile {
    name = "gnome-mimeapps";
    destination = "/share/applications/mimeapps.list";
    text = ''
      [Default Applications]
      inode/directory=nautilus.desktop;org.gnome.Nautilus.desktop
    '';
  };

  defaultFavoriteAppsOverride = ''
    [org.gnome.shell]
    favorite-apps=[ 'org.gnome.Epiphany.desktop', 'org.gnome.Geary.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Music.desktop', 'org.gnome.Photos.desktop', 'org.gnome.Nautilus.desktop' ]
  '';

  nixos-background-light = pkgs.nixos-artwork.wallpapers.simple-blue;
  nixos-background-dark = pkgs.nixos-artwork.wallpapers.simple-dark-gray;

  # TODO: Having https://github.com/NixOS/nixpkgs/issues/54150 would supersede this
  nixos-gsettings-desktop-schemas = pkgs.gnome.nixos-gsettings-overrides.override {
    inherit (cfg) extraGSettingsOverrides extraGSettingsOverridePackages favoriteAppsOverride;
    inherit flashbackEnabled nixos-background-dark nixos-background-light;
  };

  nixos-background-info = pkgs.writeTextFile rec {
    name = "nixos-background-info";
    text = ''
      <?xml version="1.0"?>
      <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
      <wallpapers>
        <wallpaper deleted="false">
          <name>Blobs</name>
          <filename>${nixos-background-light.gnomeFilePath}</filename>
          <filename-dark>${nixos-background-dark.gnomeFilePath}</filename-dark>
          <options>zoom</options>
          <shade_type>solid</shade_type>
          <pcolor>#3a4ba0</pcolor>
          <scolor>#2f302f</scolor>
        </wallpaper>
      </wallpapers>
    '';
    destination = "/share/gnome-background-properties/nixos.xml";
  };

  flashbackEnabled = cfg.flashback.enableMetacity || length cfg.flashback.customSessions > 0;
  flashbackWms = optional cfg.flashback.enableMetacity {
    wmName = "metacity";
    wmLabel = "Metacity";
    wmCommand = "${pkgs.gnome.metacity}/bin/metacity";
    enableGnomePanel = true;
  } ++ cfg.flashback.customSessions;

  notExcluded = pkg: mkDefault (!(lib.elem pkg config.environment.gnome.excludePackages));

in

{

  meta = {
    doc = ./gnome.md;
    maintainers = teams.gnome.members;
  };

  imports = [
    # Added 2021-05-07
    (mkRenamedOptionModule
      [ "services" "gnome3" "core-os-services" "enable" ]
      [ "services" "gnome" "core-os-services" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "gnome3" "core-shell" "enable" ]
      [ "services" "gnome" "core-shell" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "gnome3" "core-utilities" "enable" ]
      [ "services" "gnome" "core-utilities" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "gnome3" "core-developer-tools" "enable" ]
      [ "services" "gnome" "core-developer-tools" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "gnome3" "games" "enable" ]
      [ "services" "gnome" "games" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "gnome3" "experimental-features" "realtime-scheduling" ]
      [ "services" "gnome" "experimental-features" "realtime-scheduling" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "gnome3" "enable" ]
      [ "services" "xserver" "desktopManager" "gnome" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "gnome3" "sessionPath" ]
      [ "services" "xserver" "desktopManager" "gnome" "sessionPath" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "gnome3" "favoriteAppsOverride" ]
      [ "services" "xserver" "desktopManager" "gnome" "favoriteAppsOverride" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "gnome3" "extraGSettingsOverrides" ]
      [ "services" "xserver" "desktopManager" "gnome" "extraGSettingsOverrides" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "gnome3" "extraGSettingsOverridePackages" ]
      [ "services" "xserver" "desktopManager" "gnome" "extraGSettingsOverridePackages" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "gnome3" "debug" ]
      [ "services" "xserver" "desktopManager" "gnome" "debug" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "gnome3" "flashback" ]
      [ "services" "xserver" "desktopManager" "gnome" "flashback" ]
    )
    (mkRenamedOptionModule
      [ "environment" "gnome3" "excludePackages" ]
      [ "environment" "gnome" "excludePackages" ]
    )
    (mkRemovedOptionModule
      [ "services" "gnome" "experimental-features" "realtime-scheduling" ]
      "Set `security.rtkit.enable = true;` to make realtime scheduling possible. (Still needs to be enabled using GSettings.)"
    )
  ];

  options = {

    services.gnome = {
      core-os-services.enable = mkEnableOption (lib.mdDoc "essential services for GNOME3");
      core-shell.enable = mkEnableOption (lib.mdDoc "GNOME Shell services");
      core-utilities.enable = mkEnableOption (lib.mdDoc "GNOME core utilities");
      core-developer-tools.enable = mkEnableOption (lib.mdDoc "GNOME core developer tools");
      games.enable = mkEnableOption (lib.mdDoc "GNOME games");
    };

    services.xserver.desktopManager.gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable GNOME desktop manager.";
      };

      sessionPath = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExpression "[ pkgs.gnome.gpaste ]";
        description = lib.mdDoc ''
          Additional list of packages to be added to the session search path.
          Useful for GNOME Shell extensions or GSettings-conditional autostart.

          Note that this should be a last resort; patching the package is preferred (see GPaste).
        '';
      };

      favoriteAppsOverride = mkOption {
        internal = true; # this is messy
        default = defaultFavoriteAppsOverride;
        type = types.lines;
        example = literalExpression ''
          '''
            [org.gnome.shell]
            favorite-apps=[ 'firefox.desktop', 'org.gnome.Calendar.desktop' ]
          '''
        '';
        description = lib.mdDoc "List of desktop files to put as favorite apps into gnome-shell. These need to be installed somehow globally.";
      };

      extraGSettingsOverrides = mkOption {
        default = "";
        type = types.lines;
        description = lib.mdDoc "Additional gsettings overrides.";
      };

      extraGSettingsOverridePackages = mkOption {
        default = [];
        type = types.listOf types.path;
        description = lib.mdDoc "List of packages for which gsettings are overridden.";
      };

      debug = mkEnableOption (lib.mdDoc "gnome-session debug messages");

      flashback = {
        enableMetacity = mkEnableOption (lib.mdDoc "the standard GNOME Flashback session with Metacity");

        customSessions = mkOption {
          type = types.listOf (types.submodule {
            options = {
              wmName = mkOption {
                type = types.strMatching "[a-zA-Z0-9_-]+";
                description = lib.mdDoc "A unique identifier for the window manager.";
                example = "xmonad";
              };

              wmLabel = mkOption {
                type = types.str;
                description = lib.mdDoc "The name of the window manager to show in the session chooser.";
                example = "XMonad";
              };

              wmCommand = mkOption {
                type = types.str;
                description = lib.mdDoc "The executable of the window manager to use.";
                example = literalExpression ''"''${pkgs.haskellPackages.xmonad}/bin/xmonad"'';
              };

              enableGnomePanel = mkOption {
                type = types.bool;
                default = true;
                example = false;
                description = lib.mdDoc "Whether to enable the GNOME panel in this session.";
              };
            };
          });
          default = [];
          description = lib.mdDoc "Other GNOME Flashback sessions to enable.";
        };

        panelModulePackages = mkOption {
          default = [ pkgs.gnome.gnome-applets ];
          defaultText = literalExpression "[ pkgs.gnome.gnome-applets ]";
          type = types.listOf types.path;
          description = lib.mdDoc ''
            Packages containing modules that should be made available to `gnome-panel` (usually for applets).

            If you're packaging something to use here, please install the modules in `$out/lib/gnome-panel/modules`.
          '';
        };
      };
    };

    environment.gnome.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.gnome.totem ]";
      type = types.listOf types.package;
      description = lib.mdDoc "Which packages gnome should exclude from the default environment";
    };

  };

  config = mkMerge [
    (mkIf (cfg.enable || flashbackEnabled) {
      # Seed our configuration into nixos-generate-config
      system.nixos-generate-config.desktopConfiguration = [''
        # Enable the GNOME Desktop Environment.
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
      ''];

      services.gnome.core-os-services.enable = true;
      services.gnome.core-shell.enable = true;
      services.gnome.core-utilities.enable = mkDefault true;

      services.xserver.displayManager.sessionPackages = [ pkgs.gnome.gnome-session.sessions ];

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
    })

    (mkIf flashbackEnabled {
      services.xserver.displayManager.sessionPackages =
        let
          wmNames = map (wm: wm.wmName) flashbackWms;
          namesAreUnique = lib.unique wmNames == wmNames;
        in
          assert (assertMsg namesAreUnique "Flashback WM names must be unique.");
          map
            (wm:
              pkgs.gnome.gnome-flashback.mkSessionForWm {
                inherit (wm) wmName wmLabel wmCommand enableGnomePanel;
                inherit (cfg.flashback) panelModulePackages;
              }
            ) flashbackWms;

      security.pam.services.gnome-flashback = {
        enableGnomeKeyring = true;
      };

      systemd.packages = with pkgs.gnome; [
        gnome-flashback
      ] ++ map gnome-flashback.mkSystemdTargetForWm flashbackWms;

      environment.systemPackages = with pkgs.gnome; [
        gnome-flashback
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
      services.power-profiles-daemon.enable = mkDefault true;
      services.gnome.at-spi2-core.enable = true;
      services.gnome.evolution-data-server.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gnome.gnome-online-accounts.enable = mkDefault true;
      services.gnome.gnome-online-miners.enable = true;
      services.gnome.tracker-miners.enable = mkDefault true;
      services.gnome.tracker.enable = mkDefault true;
      services.hardware.bolt.enable = mkDefault true;
      # TODO: Enable once #177946 is resolved
      # services.packagekit.enable = mkDefault true;
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.xserver.libinput.enable = mkDefault true; # for controlling touchpad settings via gnome control center

      # Explicitly enabled since GNOME will be severely broken without these.
      xdg.mime.enable = true;
      xdg.icons.enable = true;

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        (pkgs.xdg-desktop-portal-gtk.override {
          # Do not build portals that we already have.
          buildPortalsInGnome = false;
        })
      ];

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
      services.xserver.desktopManager.gnome.sessionPath =
        let
          mandatoryPackages = [
            pkgs.gnome.gnome-shell
          ];
          optionalPackages = [
            pkgs.gnome.gnome-shell-extensions
          ];
        in
        mandatoryPackages
        ++ utils.removePackagesByName optionalPackages config.environment.gnome.excludePackages;

      services.colord.enable = mkDefault true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-browser-connector.enable = mkDefault true;
      services.gnome.gnome-initial-setup.enable = mkDefault true;
      services.gnome.gnome-remote-desktop.enable = mkDefault true;
      services.gnome.gnome-settings-daemon.enable = true;
      services.gnome.gnome-user-share.enable = mkDefault true;
      services.gnome.rygel.enable = mkDefault true;
      services.gvfs.enable = true;
      services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));

      systemd.packages = with pkgs.gnome; [
        gnome-session
        gnome-shell
      ];

      services.udev.packages = with pkgs.gnome; [
        # Force enable KMS modifiers for devices that require them.
        # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1443
        mutter
      ];

      services.avahi.enable = mkDefault true;

      xdg.portal.extraPortals = [
        pkgs.gnome.gnome-shell
      ];

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

      fonts.packages = with pkgs; [
        cantarell-fonts
        dejavu_fonts
        source-code-pro # Default monospace font in 3.32
        source-sans
      ];

      # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-38/elements/core/meta-gnome-core-shell.bst
      environment.systemPackages =
        let
          mandatoryPackages = with pkgs.gnome; [
            gnome-shell
          ];
          optionalPackages = with pkgs.gnome; [
            adwaita-icon-theme
            nixos-background-info
            gnome-backgrounds
            gnome-bluetooth
            gnome-color-manager
            gnome-control-center
            gnome-shell-extensions
            gnome-themes-extra
            pkgs.gnome-tour # GNOME Shell detects the .desktop file on first log-in.
            pkgs.gnome-user-docs
            pkgs.orca
            pkgs.glib # for gsettings program
            pkgs.gnome-menus
            pkgs.gtk3.out # for gtk-launch program
            pkgs.xdg-user-dirs # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
          ];
        in
        mandatoryPackages
        ++ utils.removePackagesByName optionalPackages config.environment.gnome.excludePackages;
    })

    # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-38/elements/core/meta-gnome-core-utilities.bst
    (mkIf serviceCfg.core-utilities.enable {
      environment.systemPackages =
        with pkgs.gnome;
        utils.removePackagesByName
          ([
            baobab
            cheese
            eog
            epiphany
            pkgs.gnome-text-editor
            gnome-calculator
            gnome-calendar
            gnome-characters
            gnome-clocks
            pkgs.gnome-console
            gnome-contacts
            gnome-font-viewer
            gnome-logs
            gnome-maps
            gnome-music
            pkgs.gnome-photos
            gnome-system-monitor
            gnome-weather
            nautilus
            pkgs.gnome-connections
            simple-scan
            totem
            yelp
          ] ++ lib.optionals config.services.flatpak.enable [
            # Since PackageKit Nix support is not there yet,
            # only install gnome-software if flatpak is enabled.
            gnome-software
          ])
          config.environment.gnome.excludePackages;

      # Enable default program modules
      # Since some of these have a corresponding package, we only
      # enable that program module if the package hasn't been excluded
      # through `environment.gnome.excludePackages`
      programs.evince.enable = notExcluded pkgs.gnome.evince;
      programs.file-roller.enable = notExcluded pkgs.gnome.file-roller;
      programs.geary.enable = notExcluded pkgs.gnome.geary;
      programs.gnome-disks.enable = notExcluded pkgs.gnome.gnome-disk-utility;
      programs.seahorse.enable = notExcluded pkgs.gnome.seahorse;
      services.gnome.sushi.enable = notExcluded pkgs.gnome.sushi;

      # VTE shell integration for gnome-console
      programs.bash.vteIntegration = mkDefault true;
      programs.zsh.vteIntegration = mkDefault true;

      # Let nautilus find extensions
      # TODO: Create nautilus-with-extensions package
      environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";

      # Override default mimeapps for nautilus
      environment.sessionVariables.XDG_DATA_DIRS = [ "${mimeAppsList}/share" ];

      environment.pathsToLink = [
        "/share/nautilus-python/extensions"
      ];
    })

    (mkIf serviceCfg.games.enable {
      environment.systemPackages = with pkgs.gnome; utils.removePackagesByName [
        aisleriot
        atomix
        five-or-more
        four-in-a-row
        pkgs.gnome-2048
        gnome-chess
        gnome-klotski
        gnome-mahjongg
        gnome-mines
        gnome-nibbles
        gnome-robots
        gnome-sudoku
        gnome-taquin
        gnome-tetravex
        hitori
        iagno
        lightsoff
        quadrapassel
        swell-foop
        tali
      ] config.environment.gnome.excludePackages;
    })

    # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/-/blob/3.38.0/elements/core/meta-gnome-core-developer-tools.bst
    (mkIf serviceCfg.core-developer-tools.enable {
      environment.systemPackages = with pkgs.gnome; utils.removePackagesByName [
        dconf-editor
        devhelp
        pkgs.gnome-builder
        # boxes would make sense in this option, however
        # it doesn't function well enough to be included
        # in default configurations.
        # https://github.com/NixOS/nixpkgs/issues/60908
        /* gnome-boxes */
      ] config.environment.gnome.excludePackages;

      services.sysprof.enable = notExcluded pkgs.sysprof;
    })
  ];

}
