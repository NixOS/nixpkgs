{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.xfce;
in

{
  options = {
    services.xserver.desktopManager.xfce = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Xfce desktop environment.";
      };

      thunarPlugins = mkOption {
        default = [];
        type = types.listOf types.package;
        example = literalExample "[ pkgs.xfce.thunar-archive-plugin ]";
        description = ''
          A list of plugin that should be installed with Thunar.
        '';
      };

      noDesktop = mkOption {
        type = types.bool;
        default = false;
        description = "Don't install XFCE desktop components (xfdesktop, panel and notification daemon).";
      };

      extraSessionCommands = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Shell commands executed just before XFCE is started.
        '';
      };

      enableXfwm = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the XFWM (default) window manager.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.xfce // pkgs; [
      # Get GTK+ themes and gtk-update-icon-cache
      gtk2.out

      # Supplies some abstract icons such as:
      # utilities-terminal, accessories-text-editor
      gnome3.defaultIconTheme

      hicolor-icon-theme
      tango-icon-theme
      xfce4-icon-theme

      # Needed by Xfce's xinitrc script
      # TODO: replace with command -v
      which

      exo
      garcon
      gtk-xfce-engine
      gvfs
      libxfce4ui
      tumbler
      xfconf

      mousepad
      ristretto
      xfce4-appfinder
      xfce4-screenshooter
      xfce4-session
      xfce4-settings
      xfce4-terminal

      (thunar.override { thunarPlugins = cfg.thunarPlugins; })
      thunar-volman # TODO: drop
    ] ++ (if config.hardware.pulseaudio.enable
          then [ xfce4-mixer-pulse xfce4-volumed-pulse ]
          else [ xfce4-mixer xfce4-volumed ])
      # TODO: NetworkManager doesn't belong here
      ++ optionals config.networking.networkmanager.enable [ networkmanagerapplet ]
      ++ optionals config.powerManagement.enable [ xfce4-power-manager ]
      ++ optionals cfg.enableXfwm [ xfwm4 ]
      ++ optionals (!cfg.noDesktop) [
        xfce4-panel
        xfce4-notifyd
        xfdesktop
      ];

    environment.pathsToLink = [
      "/share/xfce4"
      "/share/themes"
      "/share/gtksourceview-2.0"
    ];

    environment.variables = {
      GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
      GIO_EXTRA_MODULES = [ "${pkgs.xfce.gvfs}/lib/gio/modules" ];
    };

    services.xserver.desktopManager.session = [{
      name = "xfce";
      bgSupport = true;
      start = ''
        ${cfg.extraSessionCommands}

        # Set GTK_PATH so that GTK+ can find the theme engines.
        export GTK_PATH="${config.system.path}/lib/gtk-2.0:${config.system.path}/lib/gtk-3.0"

        # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
        export GTK_DATA_PREFIX=${config.system.path}

        ${pkgs.runtimeShell} ${pkgs.xfce.xinitrc} &
        waitPID=$!
      '';
    }];

    services.xserver.updateDbusEnvironment = true;

    # Enable helpful DBus services.
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;
  };
}
