{ config, lib, pkgs, ... }:

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

  nixos-gsettings-desktop-schemas = let
    defaultPackages = with pkgs; [ gsettings-desktop-schemas gnome.gnome-shell ];
  in
  pkgs.runCommand "nixos-gsettings-desktop-schemas" { preferLocalBuild = true; }
    ''
     mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     ${concatMapStrings
        (pkg: "cp -rf ${pkg}/share/gsettings-schemas/*/glib-2.0/schemas/*.xml $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas\n")
        (defaultPackages ++ cfg.extraGSettingsOverridePackages)}

     cp -f ${pkgs.gnome.gnome-shell}/share/gsettings-schemas/*/glib-2.0/schemas/*.gschema.override $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

     ${optionalString flashbackEnabled ''
       cp -f ${pkgs.gnome.gnome-flashback}/share/gsettings-schemas/*/glib-2.0/schemas/*.gschema.override $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas
     ''}

     chmod -R a+w $out/share/gsettings-schemas/nixos-gsettings-overrides
     cat - > $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/nixos-defaults.gschema.override <<- EOF
       [org.gnome.desktop.background]
       picture-uri='file://${pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}'

       [org.gnome.desktop.screensaver]
       picture-uri='file://${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath}'

       ${cfg.favoriteAppsOverride}

       ${cfg.extraGSettingsOverrides}
     EOF

     ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    '';

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
    doc = ./gnome.xml;
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
  ];

  options = {

    services.gnome = {
      core-os-services.enable = mkEnableOption "essential services for GNOME3";
      core-shell.enable = mkEnableOption "GNOME Shell services";
      core-utilities.enable = mkEnableOption "GNOME core utilities";
      core-developer-tools.enable = mkEnableOption "GNOME core developer tools";
      games.enable = mkEnableOption "GNOME games";

      experimental-features = {
        realtime-scheduling = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Makes mutter (which propagates to gnome-shell) request a low priority real-time
            scheduling which is only available on the wayland session.
            To enable this experimental feature it requires a restart of the compositor.
            Note that enabling this option only enables the <emphasis>capability</emphasis>
            for realtime-scheduling to be used. It doesn't automatically set the gsetting
            so that mutter actually uses realtime-scheduling. This would require adding <literal>
            rt-scheduler</literal> to <literal>/org/gnome/mutter/experimental-features</literal>
            with dconf-editor. You cannot use extraGSettingsOverrides because that will only
            change the default value of the setting.

            Please be aware of these known issues with the feature in nixos:
            <itemizedlist>
             <listitem>
              <para>
               <link xlink:href="https://github.com/NixOS/nixpkgs/issues/90201">NixOS/nixpkgs#90201</link>
              </para>
             </listitem>
             <listitem>
              <para>
               <link xlink:href="https://github.com/NixOS/nixpkgs/issues/86730">NixOS/nixpkgs#86730</link>
              </para>
            </listitem>
            </itemizedlist>
          '';
        };
      };
    };

    services.xserver.desktopManager.gnome = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable GNOME desktop manager.";
      };

      sessionPath = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExpression "[ pkgs.gnome.gpaste ]";
        description = ''
          Additional list of packages to be added to the session search path.
          Useful for GNOME Shell extensions or GSettings-conditional autostart.

          Note that this should be a last resort; patching the package is preferred (see GPaste).
        '';
        apply = list: list ++ [ pkgs.gnome.gnome-shell pkgs.gnome.gnome-shell-extensions ];
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
        description = "List of desktop files to put as favorite apps into gnome-shell. These need to be installed somehow globally.";
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
                type = types.strMatching "[a-zA-Z0-9_-]+";
                description = "A unique identifier for the window manager.";
                example = "xmonad";
              };

              wmLabel = mkOption {
                type = types.str;
                description = "The name of the window manager to show in the session chooser.";
                example = "XMonad";
              };

              wmCommand = mkOption {
                type = types.str;
                description = "The executable of the window manager to use.";
                example = literalExpression ''"''${pkgs.haskellPackages.xmonad}/bin/xmonad"'';
              };

              enableGnomePanel = mkOption {
                type = types.bool;
                default = true;
                example = false;
                description = "Whether to enable the GNOME panel in this session.";
              };
            };
          });
          default = [];
          description = "Other GNOME Flashback sessions to enable.";
        };

        panelModulePackages = mkOption {
          default = [ pkgs.gnome.gnome-applets ];
          defaultText = literalExpression "[ pkgs.gnome.gnome-applets ]";
          type = types.listOf types.path;
          description = ''
            Packages containing modules that should be made available to <literal>gnome-panel</literal> (usually for applets).

            If you're packaging something to use here, please install the modules in <literal>$out/lib/gnome-panel/modules</literal>.
          '';
        };
      };
    };

    environment.gnome.excludePackages = mkOption {
      default = [];
      example = literalExpression "[ pkgs.gnome.totem ]";
      type = types.listOf types.package;
      description = "Which packages gnome should exclude from the default environment";
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

       # If gnome is installed, build vim for gtk3 too.
      nixpkgs.config.vim.gui = "gtk3";
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

      # gnome-panel needs these for menu applet
      environment.sessionVariables.XDG_DATA_DIRS = [ "${pkgs.gnome.gnome-flashback}/share" ];
      # TODO: switch to sessionVariables (resolve conflict)
      environment.variables.XDG_CONFIG_DIRS = [ "${pkgs.gnome.gnome-flashback}/etc/xdg" ];
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
      services.packagekit.enable = mkDefault true;
      services.udisks2.enable = true;
      services.upower.enable = config.powerManagement.enable;
      services.xserver.libinput.enable = mkDefault true; # for controlling touchpad settings via gnome control center

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        (pkgs.xdg-desktop-portal-gtk.override {
          # Do not build portals that we already have.
          buildPortalsInGnome = false;
        })
      ];

      # Harmonize Qt5 application style and also make them use the portal for file chooser dialog.
      qt5 = {
        enable = mkDefault true;
        platformTheme = mkDefault "gnome";
        style = mkDefault "adwaita";
      };

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
      services.gnome.chrome-gnome-shell.enable = mkDefault true;
      services.gnome.glib-networking.enable = true;
      services.gnome.gnome-initial-setup.enable = mkDefault true;
      services.gnome.gnome-remote-desktop.enable = mkDefault true;
      services.gnome.gnome-settings-daemon.enable = true;
      services.gnome.gnome-user-share.enable = mkDefault true;
      services.gnome.rygel.enable = mkDefault true;
      services.gvfs.enable = true;
      services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
      services.telepathy.enable = mkDefault true;

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

      fonts.fonts = with pkgs; [
        cantarell-fonts
        dejavu_fonts
        source-code-pro # Default monospace font in 3.32
        source-sans
      ];

      # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-38/elements/core/meta-gnome-core-shell.bst
      environment.systemPackages = with pkgs.gnome; [
        adwaita-icon-theme
        gnome-backgrounds
        gnome-bluetooth
        gnome-color-manager
        gnome-control-center
        gnome-shell
        gnome-shell-extensions
        gnome-themes-extra
        pkgs.gnome-tour # GNOME Shell detects the .desktop file on first log-in.
        pkgs.nixos-artwork.wallpapers.simple-dark-gray
        pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom
        pkgs.gnome-user-docs
        pkgs.orca
        pkgs.glib # for gsettings
        pkgs.gnome-menus
        pkgs.gtk3.out # for gtk-launch
        pkgs.hicolor-icon-theme
        pkgs.shared-mime-info # for update-mime-database
        pkgs.xdg-user-dirs # Update user dirs as described in http://freedesktop.org/wiki/Software/xdg-user-dirs/
      ];
    })

    # Enable soft realtime scheduling, only supported on wayland
    (mkIf serviceCfg.experimental-features.realtime-scheduling {
      security.wrappers.".gnome-shell-wrapped" = {
        source = "${pkgs.gnome.gnome-shell}/bin/.gnome-shell-wrapped";
        owner = "root";
        group = "root";
        capabilities = "cap_sys_nice=ep";
      };

      systemd.user.services.gnome-shell-wayland = let
        gnomeShellRT = with pkgs.gnome; pkgs.runCommand "gnome-shell-rt" {} ''
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
    })

    # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/gnome-3-38/elements/core/meta-gnome-core-utilities.bst
    (mkIf serviceCfg.core-utilities.enable {
      environment.systemPackages =
        with pkgs.gnome;
        removePackagesByName
          ([
            baobab
            cheese
            eog
            epiphany
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
            pkgs.gnome-photos
            gnome-screenshot
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
      programs.gnome-terminal.enable = notExcluded pkgs.gnome.gnome-terminal;
      programs.seahorse.enable = notExcluded pkgs.gnome.seahorse;
      services.gnome.sushi.enable = notExcluded pkgs.gnome.sushi;

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
      environment.systemPackages = (with pkgs.gnome; removePackagesByName [
        aisleriot
        atomix
        five-or-more
        four-in-a-row
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
      ] config.environment.gnome.excludePackages);
    })

    # Adapt from https://gitlab.gnome.org/GNOME/gnome-build-meta/-/blob/3.38.0/elements/core/meta-gnome-core-developer-tools.bst
    (mkIf serviceCfg.core-developer-tools.enable {
      environment.systemPackages = (with pkgs.gnome; removePackagesByName [
        dconf-editor
        devhelp
        pkgs.gnome-builder
        # boxes would make sense in this option, however
        # it doesn't function well enough to be included
        # in default configurations.
        # https://github.com/NixOS/nixpkgs/issues/60908
        /* gnome-boxes */
      ] config.environment.gnome.excludePackages);

      services.sysprof.enable = notExcluded pkgs.sysprof;
    })
  ];

}
