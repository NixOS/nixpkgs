{ config, lib, pkgs, ... }:

let
  cfg = config.programs.sway;

  wayland-lib = import ./lib.nix { inherit lib; };
in
{
  options.programs.sway = {
    enable = lib.mkEnableOption ''
      Sway, the i3-compatible tiling Wayland compositor. You can manually launch
      Sway by executing "exec sway" on a TTY. Copy /etc/sway/config to
      ~/.config/sway/config to modify the default configuration. See
      <https://github.com/swaywm/sway/wiki> and
      "man 5 sway" for more information'';

    package = lib.mkPackageOption pkgs "sway" {
      nullable = true;
      extraDescription = ''
        If the package is not overridable with `extraSessionCommands`, `extraOptions`,
        `withBaseWrapper`, `withGtkWrapper`, `enableXWayland` and `isNixOS`,
        then the module options {option}`wrapperFeatures`, {option}`extraSessionCommands`,
        {option}`extraOptions` and {option}`xwayland` will have no effect.

        Set to `null` to not add any Sway package to your path.
        This should be done if you want to use the Home Manager Sway module to install Sway.
      '';
    } // {
      apply = p: if p == null then null else
        wayland-lib.genFinalPackage p {
          extraSessionCommands = cfg.extraSessionCommands;
          extraOptions = cfg.extraOptions;
          withBaseWrapper = cfg.wrapperFeatures.base;
          withGtkWrapper = cfg.wrapperFeatures.gtk;
          enableXWayland = cfg.xwayland.enable;
          isNixOS = true;
        };
    };

    wrapperFeatures = {
      base = lib.mkEnableOption ''
        the base wrapper to execute extra session commands and prepend a
        dbus-run-session to the sway command'' // { default = true; };
      gtk = lib.mkEnableOption ''
        the wrapGAppsHook wrapper to execute sway with required environment
        variables for GTK applications'';
    };

    extraSessionCommands = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        # SDL:
        export SDL_VIDEODRIVER=wayland
        # QT (needs qt5.qtwayland in systemPackages):
        export QT_QPA_PLATFORM=wayland-egl
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      description = ''
        Shell commands executed just before Sway is started. See
        <https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland>
        and <https://github.com/swaywm/wlroots/blob/master/docs/env_vars.md>
        for some useful environment variables.
      '';
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = [
        "--verbose"
        "--debug"
        "--unsupported-gpu"
      ];
      description = ''
        Command line arguments passed to launch Sway. Please DO NOT report
        issues if you use an unsupported GPU (proprietary drivers).
      '';
    };

    xwayland.enable = lib.mkEnableOption "XWayland" // { default = true; };

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      # Packages used in default config
      default = with pkgs; [ brightnessctl foot grim pulseaudio swayidle swaylock wmenu ];
      defaultText = lib.literalExpression ''
        with pkgs; [ brightnessctl foot grim pulseaudio swayidle swaylock wmenu ];
      '';
      example = lib.literalExpression ''
        with pkgs; [ i3status i3status-rust termite rofi light ]
      '';
      description = ''
        Extra packages to be installed system wide. See
        <https://github.com/swaywm/sway/wiki/Useful-add-ons-for-sway> and
        <https://github.com/swaywm/sway/wiki/i3-Migration-Guide#common-x11-apps-used-on-i3-with-wayland-alternatives>
        for a list of useful software.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.extraSessionCommands != "" -> cfg.wrapperFeatures.base;
          message = ''
            The extraSessionCommands for Sway will not be run if wrapperFeatures.base is disabled.
          '';
        }
      ];

      environment = {
        systemPackages = lib.optional (cfg.package != null) cfg.package ++ cfg.extraPackages;

        # Needed for the default wallpaper:
        pathsToLink = lib.optional (cfg.package != null) "/share/backgrounds/sway";

        etc = {
          "sway/config.d/nixos.conf".source = pkgs.writeText "nixos.conf" ''
            # Import the most important environment variables into the D-Bus and systemd
            # user environments (e.g. required for screen sharing and Pinentry prompts):
            exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
            # enable systemd-integration
            exec "systemctl --user import-environment {,WAYLAND_}DISPLAY SWAYSOCK; systemctl --user start sway-session.target"
            exec swaymsg -t subscribe '["shutdown"]' && systemctl --user stop sway-session.target
          '';
        } // lib.optionalAttrs (cfg.package != null) {
          "sway/config".source = lib.mkOptionDefault "${cfg.package}/etc/sway/config";
        };
      };

      systemd.user.targets.sway-session = {
        description = "sway compositor session";
        documentation = [ "man:systemd.special(7)" ];
        bindsTo = [ "graphical-session.target" ];
        wants = [ "graphical-session-pre.target" ];
        after = [ "graphical-session-pre.target" ];
      };

      # To make a Sway session available if a display manager like SDDM is enabled:
      services.displayManager.sessionPackages = lib.optional (cfg.package != null) cfg.package;

      # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050913
      # https://github.com/emersion/xdg-desktop-portal-wlr/blob/master/contrib/wlroots-portals.conf
      # https://github.com/emersion/xdg-desktop-portal-wlr/pull/315
      xdg.portal.config.sway = {
        # Use xdg-desktop-portal-gtk for every portal interface...
        default = "gtk";
        # ... except for the ScreenCast, Screenshot and Secret
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        # ignore inhibit bc gtk portal always returns as success,
        # despite sway/the wlr portal not having an implementation,
        # stopping firefox from using wayland idle-inhibit
        "org.freedesktop.impl.portal.Inhibit" = "none";
      };
    }

    (import ./wayland-session.nix {
      inherit lib pkgs;
      enableXWayland = cfg.xwayland.enable;
    })
  ]);

  meta.maintainers = with lib.maintainers; [ primeos colemickens ];
}
