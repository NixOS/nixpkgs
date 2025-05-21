{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

with lib;

let
  cfg = config.services.xserver.desktopManager.xfce;
  excludePackages = config.environment.xfce.excludePackages;

in
{
  meta = {
    maintainers = teams.xfce.members;
  };

  imports = [
    # added 2019-08-18
    # needed to preserve some semblance of UI familarity
    # with original XFCE module
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "xfce4-14" "extraSessionCommands" ]
      [ "services" "xserver" "displayManager" "sessionCommands" ]
    )

    # added 2019-11-04
    # xfce4-14 module removed and promoted to xfce.
    # Needed for configs that used xfce4-14 module to migrate to this one.
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "xfce4-14" "enable" ]
      [ "services" "xserver" "desktopManager" "xfce" "enable" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "xfce4-14" "noDesktop" ]
      [ "services" "xserver" "desktopManager" "xfce" "noDesktop" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "xfce4-14" "enableXfwm" ]
      [ "services" "xserver" "desktopManager" "xfce" "enableXfwm" ]
    )
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "xfce" "extraSessionCommands" ]
      [ "services" "xserver" "displayManager" "sessionCommands" ]
    )
    (mkRemovedOptionModule [ "services" "xserver" "desktopManager" "xfce" "screenLock" ] "")

    # added 2022-06-26
    # thunar has its own module
    (mkRenamedOptionModule
      [ "services" "xserver" "desktopManager" "xfce" "thunarPlugins" ]
      [ "programs" "thunar" "plugins" ]
    )
  ];

  options = {
    services.xserver.desktopManager.xfce = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Xfce desktop environment.";
      };

      noDesktop = mkOption {
        type = types.bool;
        default = false;
        description = "Don't install XFCE desktop components (xfdesktop and panel).";
      };

      enableXfwm = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the XFWM (default) window manager.";
      };

      enableScreensaver = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the XFCE screensaver.";
      };

      enableWaylandSession = mkEnableOption "the experimental Xfce Wayland session";

      waylandSessionCompositor = mkOption {
        type = lib.types.str;
        default = "";
        example = "wayfire";
        description = ''
          Command line to run a Wayland compositor, defaults to `labwc --startup`
          if not specified. Note that `xfce4-session` will be passed to it as an
          argument, see `startxfce4 --help` for details.

          Some compositors do not have an option equivalent to labwc's `--startup`
          and you might have to add xfce4-session somewhere in their configurations.
        '';
      };
    };

    environment.xfce.excludePackages = mkOption {
      default = [ ];
      example = literalExpression "[ pkgs.xfce.xfce4-volumed-pulse ]";
      type = types.listOf types.package;
      description = "Which packages XFCE should exclude from the default environment";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = utils.removePackagesByName (
      with pkgs;
      [
        glib # for gsettings
        gtk3.out # gtk-update-icon-cache

        gnome-themes-extra
        adwaita-icon-theme
        hicolor-icon-theme
        tango-icon-theme
        xfce.xfce4-icon-theme

        desktop-file-utils
        shared-mime-info # for update-mime-database

        # For a polkit authentication agent
        polkit_gnome

        # Needed by Xfce's xinitrc script
        xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/

        xfce.exo
        xfce.garcon
        xfce.libxfce4ui

        xfce.mousepad
        xfce.parole
        xfce.ristretto
        xfce.xfce4-appfinder
        xfce.xfce4-notifyd
        xfce.xfce4-screenshooter
        xfce.xfce4-session
        xfce.xfce4-settings
        xfce.xfce4-taskmanager
        xfce.xfce4-terminal
      ]
      # TODO: NetworkManager doesn't belong here
      ++ lib.optional config.networking.networkmanager.enable networkmanagerapplet
      ++ lib.optional config.powerManagement.enable xfce.xfce4-power-manager
      ++ lib.optionals (config.services.pulseaudio.enable || config.services.pipewire.pulse.enable) [
        pavucontrol
        # volume up/down keys support:
        # xfce4-pulseaudio-plugin includes all the functionalities of xfce4-volumed-pulse
        # but can only be used with xfce4-panel, so for no-desktop usage we still include
        # xfce4-volumed-pulse
        (if cfg.noDesktop then xfce.xfce4-volumed-pulse else xfce.xfce4-pulseaudio-plugin)
      ]
      ++ lib.optionals cfg.enableXfwm [
        xfce.xfwm4
        xfce.xfwm4-themes
      ]
      ++ lib.optionals (!cfg.noDesktop) [
        xfce.xfce4-panel
        xfce.xfdesktop
      ]
      ++ lib.optional cfg.enableScreensaver xfce.xfce4-screensaver
    ) excludePackages;

    programs.gnupg.agent.pinentryPackage = mkDefault pkgs.pinentry-gtk2;
    programs.xfconf.enable = true;
    programs.thunar.enable = true;
    programs.labwc.enable = mkDefault (
      cfg.enableWaylandSession
      && (cfg.waylandSessionCompositor == "" || lib.substring 0 5 cfg.waylandSessionCompositor == "labwc")
    );

    environment.pathsToLink = [
      "/share/xfce4"
      "/lib/xfce4"
      "/share/gtksourceview-3.0"
      "/share/gtksourceview-4.0"
    ];

    services.xserver.desktopManager.session = [
      {
        name = "xfce";
        prettyName = "Xfce Session";
        desktopNames = [ "XFCE" ];
        bgSupport = !cfg.noDesktop;
        start = ''
          ${pkgs.runtimeShell} ${pkgs.xfce.xfce4-session.xinitrc} &
          waitPID=$!
        '';
      }
    ];

    # Copied from https://gitlab.xfce.org/xfce/xfce4-session/-/blob/xfce4-session-4.19.2/xfce-wayland.desktop.in
    # to maintain consistent l10n state with X11 session file and to support the waylandSessionCompositor option.
    services.displayManager.sessionPackages = optionals cfg.enableWaylandSession [
      (
        (pkgs.writeTextDir "share/wayland-sessions/xfce-wayland.desktop" ''
          [Desktop Entry]
          Version=1.0
          Name=Xfce Session (Wayland)
          Comment=Use this session to run Xfce as your desktop environment
          Exec=startxfce4 --wayland ${cfg.waylandSessionCompositor}
          Icon=
          Type=Application
          DesktopNames=XFCE
          Keywords=xfce;wayland;desktop;environment;session;
        '').overrideAttrs
        (_: {
          passthru.providedSessions = [ "xfce-wayland" ];
        })
      )
    ];

    services.xserver.updateDbusEnvironment = true;
    programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

    # Enable helpful DBus services.
    services.udisks2.enable = true;
    security.polkit.enable = true;
    services.accounts-daemon.enable = true;
    services.upower.enable = config.powerManagement.enable;
    services.gnome.glib-networking.enable = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.system-config-printer.enable = (mkIf config.services.printing.enable (mkDefault true));
    services.libinput.enable = mkDefault true; # used in xfce4-settings-manager
    services.colord.enable = mkDefault true;

    # Enable default programs
    programs.dconf.enable = true;

    # Shell integration for VTE terminals
    programs.bash.vteIntegration = mkDefault true;
    programs.zsh.vteIntegration = mkDefault true;

    # Systemd services
    systemd.packages = utils.removePackagesByName (with pkgs.xfce; [
      xfce4-notifyd
    ]) excludePackages;

    security.pam.services.xfce4-screensaver.unixAuth = cfg.enableScreensaver;

    xdg.portal.configPackages = mkDefault [ pkgs.xfce.xfce4-session ];
  };
}
