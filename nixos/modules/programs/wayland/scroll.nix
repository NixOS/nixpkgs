{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  cfg = config.programs.scroll;

  wayland-lib = import (modulesPath + "/programs/wayland/lib.nix") { inherit lib; };
in
{
  options.programs.scroll = {
    enable = lib.mkEnableOption ''
      scroll, a fork of Sway (an i3-compatible Wayland compositor) with a scrolling
      tiling layout.
    '';

    package =
      lib.mkPackageOption pkgs "scroll" {
        nullable = true;
        extraDescription = ''
          If the package is not overridable with `extraSessionCommands`, `extraOptions`,
          `withBaseWrapper`, `withGtkWrapper`, `enableXWayland` and `isNixOS`,
          then the module options {option}`wrapperFeatures`, {option}`extraSessionCommands`,
          {option}`extraOptions` and {option}`xwayland` will have no effect.

          Set to `null` to not add any scroll package to your path.
          This should be done if you want to use the Home Manager module to install scroll.
        '';
      }
      // {
        apply =
          p:
          if p == null then
            null
          else
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
      base =
        lib.mkEnableOption ''
          the base wrapper to execute extra session commands and prepend a
          dbus-run-session to the scroll command''
        // {
          default = true;
        };
      gtk = lib.mkEnableOption ''
        the wrapGAppsHook wrapper to execute scroll with required environment
        variables for GTK applications'';
    };

    extraSessionCommands = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        # Sway/Scroll needs its environment variables here
        # Set GTK theme
        export GTK_THEME=Adwaita-dark
        # Tell QT, GDK and others to use the Wayland backend by default, X11 if not available
        export QT_QPA_PLATFORM="wayland;xcb"
        export GDK_BACKEND="wayland,x11"
        export SDL_VIDEODRIVER=wayland
        export CLUTTER_BACKEND=wayland

        # XDG desktop variables to set scroll as the desktop
        export XDG_CURRENT_DESKTOP=scroll
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=scroll

        # Configure Electron to use Wayland instead of X11
        export ELECTRON_OZONE_PLATFORM_HINT=wayland

        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1 # Disables window decorations on Qt applications
        export QT_QPA_PLATFORMTHEME=qt6ct
        # This is to (temporarily) fix font rendering on QWebEngineView 6
        # (qutebrowser, goldendict etc.)
        # https://bugreports.qt.io/browse/QTBUG-113574
        export QT_SCALE_FACTOR_ROUNDING_POLICY=RoundPreferFloor

        # If you use a Nvidia card
        # NVIDIA environment variables
        export LIBVA_DRIVER_NAME=nvidia
        export GBM_BACKEND=nvidia-drm
        export __GLX_VENDOR_LIBRARY_NAME=nvidia

        export XCURSOR_THEME=Adwaita
        export XCURSOR_SIZE=24
      '';
      description = ''
        Shell commands executed just before scroll is started. See
        <https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland>,
        <https://github.com/swaywm/wlroots/blob/master/docs/env_vars.md>
        and <https://github.com/dawsers/scroll#environment-variables>
        for some useful environment variables.
      '';
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--verbose"
        "--debug"
        # --unsupported-gpu isn't required on Scroll
      ];
      description = ''
        Command line arguments passed to launch scroll.
      '';
    };

    xwayland.enable = lib.mkEnableOption "XWayland" // {
      default = true;
    };

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      # Packages used in default config + portals recommended by the readme
      default = with pkgs; [
        brightnessctl
        kitty
        grim
        pulseaudio
        swayidle
        swaylock
        wmenu
      ];
      defaultText = lib.literalExpression ''
        with pkgs; [ brightnessctl kitty grim pulseaudio swayidle swaylock wmenu xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr slurp ];
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

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = cfg.extraSessionCommands != "" -> cfg.wrapperFeatures.base;
            message = ''
              The extraSessionCommands for scroll will not be run if wrapperFeatures.base is disabled.
            '';
          }
        ];

        warnings =
          lib.mkIf
            (
              (lib.elem "nvidia" config.services.xserver.videoDrivers)
              && (lib.versionOlder (lib.versions.major (lib.getVersion config.hardware.nvidia.package)) "551")
            )
            [
              "Using scroll with Nvidia driver version <= 550 may result in a poor experience. Configure hardware.nvidia.package to use a newer version, or alternatively switch to using Nouveau."
            ];

        environment = {
          systemPackages = lib.optional (cfg.package != null) cfg.package ++ cfg.extraPackages;

          # include the default sway wallpapers because they're apparently still here
          pathsToLink = lib.optional (cfg.package != null) "/share/backgrounds/scroll";

          etc = {
            "scroll/config.d/nixos.conf".source = pkgs.writeText "nixos.conf" ''
              # Import the most important environment variables into the D-Bus and systemd
              # user environments (e.g. required for screen sharing and Pinentry prompts):
              exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY I3SOCK SWAYSOCK SCROLLSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE PATH NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE
              # enable systemd-integration
              exec "systemctl --user import-environment {,WAYLAND_}DISPLAY I3SOCK SWAYSOCK SCROLLSOCK; systemctl --user start scroll-session.target"
              exec scrollmsg -t subscribe '["shutdown"]' && systemctl --user stop scroll-session.target
            '';
          }
          // lib.optionalAttrs (cfg.package != null) {
            "scroll/config".source = lib.mkOptionDefault "${cfg.package}/etc/scroll/config";
          };
        };

        systemd.user.targets.scroll-session = {
          description = "scroll compositor session";
          documentation = [ "man:systemd.special(7)" ];
          bindsTo = [ "graphical-session.target" ];
          wants = [ "graphical-session-pre.target" ];
          after = [ "graphical-session-pre.target" ];
        };

        # To make a scroll session available if a display manager like SDDM is enabled:
        services.displayManager.sessionPackages = lib.optional (cfg.package != null) cfg.package;

        # Set up XDG portal config how it's suggested in the readme
        xdg.portal.config.scroll = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
          "org.freedesktop.impl.portal.Inhibit" = "none";
        };
      }

      (import ./wayland-session.nix {
        inherit lib pkgs;
        enableXWayland = cfg.xwayland.enable;
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [ olimoli ];
}
