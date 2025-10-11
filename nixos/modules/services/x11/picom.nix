{ lib, pkgs, config, formats, ... }:

with lib;

let
  cfg = config.services.picom;

  # This helper function creates an option for the submodule.
  # It prevents repeating the type and description boilerplate.
  mkPicomOption = name: type: description:
    mkOption {
      inherit description;
      type = with types; nullOr type;
      default = null;
      example = if type == types.bool then true else if type == types.int then 10 else if type == types.float then 0.75 else null;
    };

in {
  options.services.picom = {
    enable = mkEnableOption "Whether to enable Picom, the X.org compositor.";

    package = mkOption {
      type = types.package;
      default = pkgs.picom;
      defaultText = literalExpression "pkgs.picom";
      description = "The Picom package to use.";
    };

    # The legacy top-level options are preserved for backward compatibility.
    # They now forward their values to the new `settings` submodule with low priority.

    backend = mkOption {
      type = types.str;
      default = "glx";
      description = "Rendering backend to use. Common values include `glx` and `xrender`.";
    };

    vsync = mkOption {
      type = types.bool;
      default = true;
      description = "Enable VSync to prevent screen tearing.";
    };

    shadow = mkOption {
      type = types.bool;
      default = true;
      description = "Enable shadows on windows and panels.";
    };

    shadowRadius = mkOption {
      type = types.int;
      default = 12;
      description = "The blur radius for shadows, in pixels.";
    };

    shadowOffsetX = mkOption {
      type = types.int;
      default = -15;
      description = "The horizontal offset for shadows, in pixels.";
    };

    shadowOffsetY = mkOption {
      type = types.int;
      default = -15;
      description = "The vertical offset for shadows, in pixels.";
    };

    fade = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fading for windows during state changes (e.g., opening, closing).";
    };

    fadeDelta = mkOption {
      type = types.int;
      default = 10;
      description = "The time in milliseconds between steps in a fade transition.";
    };



    fadeInStep = mkOption {
      type = types.float;
      default = 0.03;
      description = "The opacity change between steps for fade-in transitions.";
    };

    fadeOutStep = mkOption {
      type = types.float;
      default = 0.03;
      description = "The opacity change between steps for fade-out transitions.";
    };

    fadeExclude = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of conditions for windows that should be excluded from fading.";
      example = literalExpression ''[ "class_g = 'slock'" ]'';
    };

    cornerRadius = mkOption {
      type = types.int;
      default = 10;
      description = "The radius of rounded corners on windows, in pixels.";
    };

    shadowExclude = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of conditions for windows that should be excluded from shadows.";
      example = literalExpression ''[ "name = 'Notification'" ]'';
    };

    opacityRules = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "A list of opacity rules for specific windows.";
      example = literalExpression ''[ "80:class_g = 'URxvt'" ]'';
    };

    blurMethod = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The blur method to use. Requires a Picom fork with blur support. Common values are `dual_kawase` or `kernel`.";
    };

    blurSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "The size of the blur kernel.";
    };

    blurStrength = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "The strength of the blur, used by methods like `dual_kawase`.";
    };

    blurDeviation = mkOption {
      type = types.nullOr types.float;
      default = null;
      description = "The standard deviation for the Gaussian blur kernel.";
    };

    blurBackground = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to blur the background of transparent windows.";
    };

    blurBackgroundFrame = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to blur the background of windows when the frame is not opaque.";
    };

    inactiveOpacity = mkOption {
      type = types.float;
      default = 1.0;
      description = "The opacity of inactive windows, from 0.0 to 1.0.";
    };

    activeOpacity = mkOption {
      type = types.float;
      default = 1.0;
      description = "The opacity of the active window, from 0.0 to 1.0.";
    };

    detectClientOpacity = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to respect the opacity property set by applications (_NET_WM_WINDOW_OPACITY).";
    };

    detectTransient = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to detect transient windows (e.g., dialogs, pop-ups).";
    };

    detectRoundedCorners = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to detect rounded corners set by applications.";
    };

    markWmwinFocused = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to mark WM windows as focused.";
    };

    settings = mkOption {
      type = with types; submodule {
        # This allows users to add any picom setting, even if it's not
        # explicitly defined as an option below.
        freeformType = formats.libconfig.type;
        options = {
          # Explicit definitions provide type safety and documentation for common options.
          # The `mkPicomOption` helper reduces boilerplate.
          backend = mkPicomOption "backend" types.str "Rendering backend to use.";
          vsync = mkPicomOption "vsync" types.bool "Enable VSync to prevent screen tearing.";
          shadow = mkPicomOption "shadow" types.bool "Enable shadows on windows.";
          "shadow-radius" = mkPicomOption "shadow-radius" types.int "The blur radius for shadows.";
          "shadow-offset-x" = mkPicomOption "shadow-offset-x" types.int "The horizontal offset for shadows.";
          "shadow-offset-y" = mkPicomOption "shadow-offset-y" types.int "The vertical offset for shadows.";
          fade = mkPicomOption "fade" types.bool "Enable fading for windows.";
          "fade-delta" = mkPicomOption "fade-delta" types.int "Time in milliseconds between fade steps.";
          "fade-in-step" = mkPicomOption "fade-in-step" types.float "Opacity change per step for fade-in.";
          "fade-out-step" = mkPicomOption "fade-out-step" types.float "Opacity change per step for fade-out.";
          "fade-exclude" = mkPicomOption "fade-exclude" (types.listOf types.str) "Windows to exclude from fading.";
          "corner-radius" = mkPicomOption "corner-radius" types.int "Radius of rounded corners on windows.";
          "shadow-exclude" = mkPicomOption "shadow-exclude" (types.listOf types.str) "Windows to exclude from shadows.";
          "opacity-rule" = mkPicomOption "opacity-rule" (types.listOf types.str) "Opacity rules for specific windows.";
          "blur-method" = mkPicomOption "blur-method" types.str "Blur method to use (e.g., 'dual_kawase').";
          "blur-size" = mkPicomOption "blur-size" types.int "Size of the blur kernel.";
          "blur-strength" = mkPicomOption "blur-strength" types.int "Strength of the blur.";
          "blur-deviation" = mkPicomOption "blur-deviation" types.float "Standard deviation for Gaussian blur.";
          "blur-background" = mkPicomOption "blur-background" types.bool "Blur the background of transparent windows.";
          "blur-background-frame" = mkPicomOption "blur-background-frame" types.bool "Blur the background of the window frame.";
          "inactive-opacity" = mkPicomOption "inactive-opacity" types.float "Opacity of inactive windows.";
          "active-opacity" = mkPicomOption "active-opacity" types.float "Opacity of the active window.";
          "detect-client-opacity" = mkPicomOption "detect-client-opacity" types.bool "Respect opacity set by applications.";
          "detect-transient" = mkPicomOption "detect-transient" types.bool "Detect transient windows like dialogs.";
          "detect-rounded-corners" = mkPicomOption "detect-rounded-corners" types.bool "Detect rounded corners set by applications.";
          "mark-wmwin-focused" = mkPicomOption "mark-wmwin-focused" types.bool "Mark WM windows as focused.";
        };
      };
      default = { };
      description = ''
        Declarative Picom configuration using a submodule.
        Settings defined here take precedence over the top-level options
        (e.g., `services.picom.backend`). This is the recommended way to configure Picom.
      '';
      example = literalExpression ''
        {
          backend = "glx";
          vsync = true;
          "corner-radius" = 10;
          # This option is not available at the top level
          "dbe" = false;
        }
      '';
    };
  };

  # The main configuration block
  config = mkIf cfg.enable {
    # This is the core of the fix. It uses the NixOS module system's merge
    # capabilities. Values from the top-level options are assigned to the new
    # `settings` submodule with `mkDefault`, giving them low priority.
    # This means any value explicitly set by the user in `services.picom.settings`
    # will win, perfectly replicating the old behavior in an idiomatic way.
    services.picom.settings = mkDefault {
      backend = cfg.backend;
      vsync = cfg.vsync;
      shadow = cfg.shadow;
      "shadow-radius" = cfg.shadowRadius;
      "shadow-offset-x" = cfg.shadowOffsetX;
      "shadow-offset-y" = cfg.shadowOffsetY;
      fade = cfg.fade;
      "fade-delta" = cfg.fadeDelta;
      "fade-in-step" = cfg.fadeInStep;
      "fade-out-step" = cfg.fadeOutStep;
      "fade-exclude" = cfg.fadeExclude;
      "corner-radius" = cfg.cornerRadius;
      "shadow-exclude" = cfg.shadowExclude;
      "opacity-rule" = cfg.opacityRules;
      "blur-method" = cfg.blurMethod;
      "blur-size" = cfg.blurSize;
      "blur-strength" = cfg.blurStrength;
      "blur-deviation" = cfg.blurDeviation;
      "blur-background" = cfg.blurBackground;
      "blur-background-frame" = cfg.blurBackgroundFrame;
      "inactive-opacity" = cfg.inactiveOpacity;
      "active-opacity" = cfg.activeOpacity;
      "detect-client-opacity" = cfg.detectClientOpacity;
      "detect-transient" = cfg.detectTransient;
      "detect-rounded-corners" = cfg.detectRoundedCorners;
      "mark-wmwin-focused" = cfg.markWmwinFocused;
    };

    environment.systemPackages = [ cfg.package ];

    # The config file is now generated from `cfg.settings`, which is the
    # fully merged result from the module system.
    environment.etc."xdg/picom/picom.conf".source =
      formats.libconfig.generate "picom.conf" cfg.settings;

    systemd.user.services.picom = {
      description = "Picom compositor for X11";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/picom --config /etc/xdg/picom/picom.conf";
        RestartSec = 3;
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];
}
