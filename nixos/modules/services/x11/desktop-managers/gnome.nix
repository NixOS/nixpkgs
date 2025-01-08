{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

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
    favorite-apps=[ 'org.gnome.Epiphany.desktop', 'org.gnome.Geary.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Music.desktop', 'org.gnome.Nautilus.desktop' ]
  '';

  nixos-background-light = pkgs.nixos-artwork.wallpapers.simple-blue;
  nixos-background-dark = pkgs.nixos-artwork.wallpapers.simple-dark-gray;

  # TODO: Having https://github.com/NixOS/nixpkgs/issues/54150 would supersede this
  nixos-gsettings-desktop-schemas = pkgs.gnome.nixos-gsettings-overrides.override {
    inherit (cfg) extraGSettingsOverrides extraGSettingsOverridePackages favoriteAppsOverride;
    inherit flashbackEnabled nixos-background-dark nixos-background-light;
  };

  nixos-background-info = pkgs.writeTextFile {
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

  flashbackEnabled = cfg.flashback.enableMetacity || lib.length cfg.flashback.customSessions > 0;
  flashbackWms =
    lib.optional cfg.flashback.enableMetacity {
      wmName = "metacity";
      wmLabel = "Metacity";
      wmCommand = "${pkgs.metacity}/bin/metacity";
      enableGnomePanel = true;
    }
    ++ cfg.flashback.customSessions;

  notExcluded =
    pkg: lib.mkDefault (utils.disablePackageByName pkg config.environment.gnome.excludePackages);

in

{

  meta = {
    doc = ./gnome.md;
    maintainers = lib.teams.gnome.members;
  };

  options = {

    services.gnome = {
      core-os-services.enable = lib.mkEnableOption "essential services for GNOME3";
      core-shell.enable = lib.mkEnableOption "GNOME Shell services";
      core-utilities.enable = lib.mkEnableOption "GNOME core utilities";
      core-developer-tools.enable = lib.mkEnableOption "GNOME core developer tools";
      games.enable = lib.mkEnableOption "GNOME games";
    };

    services.xserver.desktopManager.gnome = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable GNOME desktop manager.";
      };

      sessionPath = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
        example = lib.literalExpression "[ pkgs.gpaste ]";
        description = ''
          Additional list of packages to be added to the session search path.
          Useful for GNOME Shell extensions or GSettings-conditional autostart.

          Note that this should be a last resort; patching the package is preferred (see GPaste).
        '';
      };

      favoriteAppsOverride = lib.mkOption {
        internal = true; # this is messy
        default = defaultFavoriteAppsOverride;
        type = lib.types.lines;
        example = lib.literalExpression ''
          '''
            [org.gnome.shell]
            favorite-apps=[ 'firefox.desktop', 'org.gnome.Calendar.desktop' ]
          '''
        '';
        description = "List of desktop files to put as favorite apps into pkgs.gnome-shell. These need to be installed somehow globally.";
      };

      extraGSettingsOverrides = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = "Additional gsettings overrides.";
      };

      extraGSettingsOverridePackages = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.path;
        description = "List of packages for which gsettings are overridden.";
      };

      debug = lib.mkEnableOption "pkgs.gnome-session debug messages";

      flashback = {
        enableMetacity = lib.mkEnableOption "the standard GNOME Flashback session with Metacity";

        customSessions = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                wmName = lib.mkOption {
                  type = lib.types.strMatching "[a-zA-Z0-9_-]+";
                  description = "A unique identifier for the window manager.";
                  example = "xmonad";
                };

                wmLabel = lib.mkOption {
                  type = lib.types.str;
                  description = "The name of the window manager to show in the session chooser.";
                  example = "XMonad";
                };

                wmCommand = lib.mkOption {
                  type = lib.types.str;
                  description = "The executable of the window manager to use.";
                  example = lib.literalExpression ''"''${pkgs.haskellPackages.xmonad}/bin/xmonad"'';
                };

                enableGnomePanel = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  example = false;
                  description = "Whether to enable the GNOME panel in this session.";
                };
              };
            }
          );
          default = [ ];
          description = "Other GNOME Flashback sessions to enable.";
        };

        panelModulePackages = lib.mkOption {
          default = [ pkgs.gnome-applets ];
          defaultText = lib.literalExpression "[ pkgs.gnome-applets ]";
          type = lib.types.listOf lib.types.package;
          description = ''
            Packages containing modules that should be made available to `pkgs.gnome-panel` (usually for applets).

            If you're packaging something to use here, please install the modules in `$out/lib/gnome-panel/modules`.
          '';
        };
      };
    };

    environment.gnome.excludePackages = lib.mkOption {
      default = [ ];
      example = lib.literalExpression "[ pkgs.totem ]";
      type = lib.types.listOf lib.types.package;
      description = "Which packages gnome should exclude from the default environment";
    };

  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable || flashbackEnabled) {
      # Seed our configuration into nixos-generate-config
      system.nixos-generate-config.desktopConfiguration = [
        ''
          # Enable the GNOME Desktop Environment.
          services.xserver.displayManager.gdm.enable = true;
          services.xserver.desktopManager.gnome.enable = true;
        ''
      ];

      services.gnome.core-os-services.enable = true;
      services.gnome.core-shell.enable = true;
      services.gnome.core-utilities.enable = lib.mkDefault true;

      services.displayManager.sessionPackages = [ pkgs.gnome-session.sessions ];

      environment.extraInit = ''
        ${lib.concatMapStrings (p: ''
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

      environment.sessionVariables.GNOME_SESSION_DEBUG = lib.mkIf cfg.debug "1";

      # Override GSettings schemas
      environment.sessionVariables.NIX_GSETTINGS_OVERRIDES_DIR = "${nixos-gsettings-desktop-schemas}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
    })

    (lib.mkIf flashbackEnabled {
      services.displayManager.sessionPackages =
        let
          wmNames = map (wm: wm.wmName) flashbackWms;
          namesAreUnique = lib.unique wmNames == wmNames;
        in
        assert (lib.assertMsg namesAreUnique "Flashback WM names must be unique.");
        map (
          wm:
          pkgs.gnome-flashback.mkSessionForWm {
            inherit (wm) wmName wmLabel wmCommand;
          }
        ) flashbackWms;

      security.pam.services.gnome-flashback = {
        enableGnomeKeyring = true;
      };

      systemd.packages = [
        pkgs.gnome-flashback
      ] ++ map pkgs.gnome-flashback.mkSystemdTargetForWm flashbackWms;

      environment.systemPackages =
        [
          pkgs.gnome-flashback
          (pkgs.gnome-panel-with-modules.override {
            panelModulePackages = cfg.flashback.panelModulePackages;
          })
        ]
        # For /share/applications/${wmName}.desktop
        ++ (map (
          wm: pkgs.gnome-flashback.mkWmApplication { inherit (wm) wmName wmLabel wmCommand; }
        ) flashbackWms)
        # For /share/pkgs.gnome-session/sessions/gnome-flashback-${wmName}.session
        ++ (map (
          wm: pkgs.gnome-flashback.mkGnomeSession { inherit (wm) wmName wmLabel enableGnomePanel; }
        ) flashbackWms);
    })

    (lib.mkIf serviceCfg.core-os-services.enable {
      hardware.bluetooth.enable = lib.mkDefault true;
      programs.dconf.enable = true;
      security.polkit.enable = true;
      services.accounts-daemon.enable = true;
      services.dleyna-renderer.enable = lib.mkDefault true;
      services.dleyna-server.enable = lib.mkDefault true;
      services.power-profiles-daemon.enable = lib.mkDefault true;
      services.gnome.at-spi2-core.enable = true;
      services.gnome.evolution-data-server.enable = true;
      services.gnome.gnome-keyring.enable = true;
      services.gnome.gnome-online-accounts.enable = lib.mkDefault true;
      services.gnome.localsearch.enable = lib.mkDefault true;
      services.gnome.tinysparql.enable = lib.mkDefault true;
      services.hardware.bolt.enable = lib.mkDefault true;
      # TODO: Enable once #177946 is resolved
      # services.packagekit.enable = lib.mkDefault true;
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.libinput.enable = lib.mkDefault true; # for controlling touchpad settings via gnome control center

      # Explicitly enabled since GNOME will be severely broken without these.
      xdg.mime.enable = true;
      xdg.icons.enable = true;

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      xdg.portal.configPackages = lib.mkDefault [ pkgs.gnome-session ];

      networking.networkmanager.enable = lib.mkDefault true;

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

    (lib.mkIf serviceCfg.core-shell.enable {
      services.xserver.desktopManager.gnome.sessionPath =
        let
          mandatoryPackages = [
            pkgs.gnome-shell
          ];
          lib.optionalPackages = [
            pkgs.gnome-shell-extensions
          ];
        in
        mandatoryPackages
        ++ utils.removePackagesByName lib.optionalPackages config.environment.gnome.excludePackages;

      services.colord.enable = lib.mkDefault true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-browser-connector.enable = lib.mkDefault true;
      services.gnome.gnome-initial-setup.enable = lib.mkDefault true;
      services.gnome.gnome-remote-desktop.enable = lib.mkDefault true;
      services.gnome.gnome-settings-daemon.enable = true;
      services.gnome.gnome-user-share.enable = lib.mkDefault true;
      services.gnome.rygel.enable = lib.mkDefault true;
      services.gvfs.enable = true;
      services.system-config-printer.enable = (lib.mkIf config.services.printing.enable (lib.mkDefault true));

      systemd.packages = [
        pkgs.gnome-session
        pkgs.gnome-shell
      ];

      services.udev.packages = [
        # Force enable KMS modifiers for devices that require them.
        # https://gitlab.gnome.org/GNOME/pkgs.mutter/-/merge_requests/1443
        pkgs.mutter
      ];

      services.avahi.enable = lib.mkDefault true;

      services.geoclue2.enable = lib.mkDefault true;
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

      services.orca.enable = notExcluded pkgs.orca;

      fonts.packages = with pkgs; [
        cantarell-fonts
        dejavu_fonts
        source-code-pro # Default monospace font in 3.32
        source-sans
      ];

      # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-38/elements/core/meta-gnome-core-shell.bst
      environment.systemPackages =
        let
          mandatoryPackages = [
            pkgs.gnome-shell
          ];
          lib.optionalPackages = [
            pkgs.adwaita-icon-theme
            nixos-background-info
            pkgs.gnome-backgrounds
            pkgs.gnome-bluetooth
            pkgs.gnome-color-manager
            pkgs.gnome-control-center
            pkgs.gnome-shell-extensions
            pkgs.gnome-tour # GNOME Shell detects the .desktop file on first log-in.
            pkgs.gnome-user-docs
            pkgs.glib # for gsettings program
            pkgs.gnome-menus
            pkgs.gtk3.out # for gtk-launch program
            pkgs.xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
            pkgs.xdg-user-dirs-gtk # Used to create the default bookmarks
          ];
        in
        mandatoryPackages
        ++ utils.removePackagesByName lib.optionalPackages config.environment.gnome.excludePackages;
    })

    # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/-/blob/gnome-45/elements/core/meta-gnome-core-utilities.bst
    (lib.mkIf serviceCfg.core-utilities.enable {
      environment.systemPackages = utils.removePackagesByName (
        [
          pkgs.baobab
          pkgs.epiphany
          pkgs.gnome-text-editor
          pkgs.gnome-calculator
          pkgs.gnome-calendar
          pkgs.gnome-characters
          pkgs.gnome-clocks
          pkgs.gnome-console
          pkgs.gnome-contacts
          pkgs.gnome-font-viewer
          pkgs.gnome-logs
          pkgs.gnome-maps
          pkgs.gnome-music
          pkgs.gnome-system-monitor
          pkgs.gnome-weather
          pkgs.loupe
          pkgs.nautilus
          pkgs.gnome-connections
          pkgs.simple-scan
          pkgs.snapshot
          pkgs.totem
          pkgs.yelp
        ]
        ++ lib.optionals config.services.flatpak.enable [
          # Since PackageKit Nix support is not there yet,
          # only install gnome-software if flatpak is enabled.
          pkgs.gnome-software
        ]
      ) config.environment.gnome.excludePackages;

      # Enable default program modules
      # Since some of these have a corresponding package, we only
      # enable that program module if the package hasn't been excluded
      # through `environment.gnome.excludePackages`
      programs.evince.enable = notExcluded pkgs.evince;
      programs.file-roller.enable = notExcluded pkgs.file-roller;
      programs.geary.enable = notExcluded pkgs.geary;
      programs.gnome-disks.enable = notExcluded pkgs.gnome-disk-utility;
      programs.seahorse.enable = notExcluded pkgs.seahorse;
      services.gnome.sushi.enable = notExcluded pkgs.sushi;

      # VTE shell integration for gnome-console
      programs.bash.vteIntegration = lib.mkDefault true;
      programs.zsh.vteIntegration = lib.mkDefault true;

      # Let nautilus find extensions
      # TODO: Create nautilus-with-extensions package
      environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";

      # Override default mimeapps for nautilus
      environment.sessionVariables.XDG_DATA_DIRS = [ "${mimeAppsList}/share" ];

      environment.pathsToLink = [
        "/share/nautilus-python/extensions"
      ];
    })

    (lib.mkIf serviceCfg.games.enable {
      environment.systemPackages = utils.removePackagesByName [
        pkgs.aisleriot
        pkgs.atomix
        pkgs.five-or-more
        pkgs.four-in-a-row
        pkgs.gnome-2048
        pkgs.gnome-chess
        pkgs.gnome-klotski
        pkgs.gnome-mahjongg
        pkgs.gnome-mines
        pkgs.gnome-nibbles
        pkgs.gnome-robots
        pkgs.gnome-sudoku
        pkgs.gnome-taquin
        pkgs.gnome-tetravex
        pkgs.hitori
        pkgs.iagno
        pkgs.lightsoff
        pkgs.quadrapassel
        pkgs.swell-foop
        pkgs.tali
      ] config.environment.gnome.excludePackages;
    })

    # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/-/blob/3.38.0/elements/core/meta-gnome-core-developer-tools.bst
    (lib.mkIf serviceCfg.core-developer-tools.enable {
      environment.systemPackages = utils.removePackagesByName [
        pkgs.dconf-editor
        pkgs.devhelp
        pkgs.gnome-builder
        # boxes would make sense in this option, however
        # it doesn't function well enough to be included
        # in default configurations.
        # https://github.com/NixOS/nixpkgs/issues/60908
        # pkgs.gnome-boxes
      ] config.environment.gnome.excludePackages;

      services.sysprof.enable = notExcluded pkgs.sysprof;
    })
  ];

}
