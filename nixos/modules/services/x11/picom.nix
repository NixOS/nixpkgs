{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.picom;

  derivedSettings = {
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
  } // cfg.settings; # Allows overrides via `settings`
in {
  options.services.picom = {
    enable = mkEnableOption "Whether or not to enable Picom as the X.org composite manager.";

    package = mkOption {
      type = types.package;
      default = pkgs.picom;
      defaultText = literalExpression "pkgs.picom";
      description = "The picom package to use.";
    };

    backend = mkOption {
      type = types.str;
      default = "glx";
      description = "Rendering backend.";
    };

    vsync = mkOption {
      type = types.bool;
      default = true;
      description = "Enable VSync.";
    };

    shadow = mkOption {
      type = types.bool;
      default = true;
      description = "Enable shadows.";
    };

    shadowRadius = mkOption {
      type = types.int;
      default = 12;
      description = "Blur radius for shadows.";
    };

    shadowOffsetX = mkOption {
      type = types.int;
      default = -15;
      description = "Horizontal shadow offset.";
    };

    shadowOffsetY = mkOption {
      type = types.int;
      default = -15;
      description = "Vertical shadow offset.";
    };

    fade = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fading for windows.";
    };

    fadeDelta = mkOption {
      type = types.int;
      default = 10;
      description = "Fade transition speed (ms between steps).";
    };

    fadeInStep = mkOption {
      type = types.float;
      default = 0.03;
      description = "Amount of opacity increase per fade-in step.";
    };

    fadeOutStep = mkOption {
      type = types.float;
      default = 0.03;
      description = "Amount of opacity decrease per fade-out step.";
    };

    fadeExclude = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Exclude certain windows from fading.";
    };

    cornerRadius = mkOption {
      type = types.int;
      default = 10;
      description = "Rounded corner radius.";
    };

    shadowExclude = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Exclude certain windows from shadows.";
    };

    opacityRules = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Opacity rules for specific windows.";
    };

    blurMethod = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Blur method to use (e.g. 'dual_kawase').";
    };

    blurSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Size of blur kernel.";
    };

    blurStrength = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Strength of blur (if applicable).";
    };

    blurDeviation = mkOption {
      type = types.nullOr types.float;
      default = null;
      description = "Deviation for Gaussian blur.";
    };

    blurBackground = mkOption {
      type = types.bool;
      default = false;
      description = "Blur window background.";
    };

    blurBackgroundFrame = mkOption {
      type = types.bool;
      default = false;
      description = "Blur window frame background.";
    };

    inactiveOpacity = mkOption {
      type = types.float;
      default = 1.0;
      description = "Opacity of inactive windows.";
    };

    activeOpacity = mkOption {
      type = types.float;
      default = 1.0;
      description = "Opacity of active windows.";
    };

    detectClientOpacity = mkOption {
      type = types.bool;
      default = true;
      description = "Respect client window opacity.";
    };

    detectTransient = mkOption {
      type = types.bool;
      default = true;
      description = "Detect transient windows.";
    };

    detectRoundedCorners = mkOption {
      type = types.bool;
      default = true;
      description = "Detect rounded corners.";
    };

    markWmwinFocused = mkOption {
      type = types.bool;
      default = true;
      description = "Mark wmwin windows as focused.";
    };

    settings = mkOption {
      type = formats.libconfig.type;
      default = { };
      description = "Picom configuration in libconfig format.";
      example = literalExpression ''
        {
          backend = "glx";
          vsync = true;
          "corner-radius" = 10;
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."xdg/picom/picom.conf".source =
      formats.libconfig.generate "picom.conf" derivedSettings;

    systemd.user.services.picom = {
      description = "Picom composite manager";
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
