{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.xserver.synaptics;
  opt = options.services.xserver.synaptics;
  tapConfig = if cfg.tapButtons then enabledTapConfig else disabledTapConfig;
  enabledTapConfig = ''
    Option "MaxTapTime" "180"
    Option "MaxTapMove" "220"
    Option "TapButton1" "${builtins.elemAt cfg.fingersMap 0}"
    Option "TapButton2" "${builtins.elemAt cfg.fingersMap 1}"
    Option "TapButton3" "${builtins.elemAt cfg.fingersMap 2}"
  '';
  disabledTapConfig = ''
    Option "MaxTapTime" "0"
    Option "MaxTapMove" "0"
    Option "TapButton1" "0"
    Option "TapButton2" "0"
    Option "TapButton3" "0"
  '';
  pkg = pkgs.xorg.xf86inputsynaptics;
  etcFile = "X11/xorg.conf.d/70-synaptics.conf";
in
{

  options = {

    services.xserver.synaptics = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable touchpad support. Deprecated: Consider services.libinput.enable.";
      };

      dev = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/dev/input/event0";
        description = ''
          Path for touchpad device.  Set to null to apply to any
          auto-detected touchpad.
        '';
      };

      accelFactor = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "0.001";
        description = "Cursor acceleration (how fast speed increases from minSpeed to maxSpeed).";
      };

      minSpeed = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "0.6";
        description = "Cursor speed factor for precision finger motion.";
      };

      maxSpeed = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "1.0";
        description = "Cursor speed factor for highest-speed finger motion.";
      };

      scrollDelta = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 75;
        description = "Move distance of the finger for a scroll event.";
      };

      twoFingerScroll = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable two-finger drag-scrolling. Overridden by horizTwoFingerScroll and vertTwoFingerScroll.";
      };

      horizTwoFingerScroll = lib.mkOption {
        type = lib.types.bool;
        default = cfg.twoFingerScroll;
        defaultText = lib.literalExpression "config.${opt.twoFingerScroll}";
        description = "Whether to enable horizontal two-finger drag-scrolling.";
      };

      vertTwoFingerScroll = lib.mkOption {
        type = lib.types.bool;
        default = cfg.twoFingerScroll;
        defaultText = lib.literalExpression "config.${opt.twoFingerScroll}";
        description = "Whether to enable vertical two-finger drag-scrolling.";
      };

      horizEdgeScroll = lib.mkOption {
        type = lib.types.bool;
        default = !cfg.horizTwoFingerScroll;
        defaultText = lib.literalExpression "! config.${opt.horizTwoFingerScroll}";
        description = "Whether to enable horizontal edge drag-scrolling.";
      };

      vertEdgeScroll = lib.mkOption {
        type = lib.types.bool;
        default = !cfg.vertTwoFingerScroll;
        defaultText = lib.literalExpression "! config.${opt.vertTwoFingerScroll}";
        description = "Whether to enable vertical edge drag-scrolling.";
      };

      tapButtons = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable tap buttons.";
      };

      buttonsMap = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        default = [
          1
          2
          3
        ];
        example = [
          1
          3
          2
        ];
        description = "Remap touchpad buttons.";
        apply = map toString;
      };

      fingersMap = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        default = [
          1
          2
          3
        ];
        example = [
          1
          3
          2
        ];
        description = "Remap several-fingers taps.";
        apply = map toString;
      };

      palmDetect = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable palm detection (hardware support required)";
      };

      palmMinWidth = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 5;
        description = "Minimum finger width at which touch is considered a palm";
      };

      palmMinZ = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 20;
        description = "Minimum finger pressure at which touch is considered a palm";
      };

      horizontalScroll = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable horizontal scrolling (on touchpad)";
      };

      additionalOptions = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = ''
          Option "RTCornerButton" "2"
          Option "RBCornerButton" "3"
        '';
        description = ''
          Additional options for synaptics touchpad driver.
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    services.xserver.modules = [ pkg.out ];

    environment.etc.${etcFile}.source = "${pkg.out}/share/X11/xorg.conf.d/70-synaptics.conf";

    environment.systemPackages = [ pkg ];

    services.xserver.config = ''
      # Automatically enable the synaptics driver for all touchpads.
      Section "InputClass"
        Identifier "synaptics touchpad catchall"
        MatchIsTouchpad "on"
        ${lib.optionalString (cfg.dev != null) ''MatchDevicePath "${cfg.dev}"''}
        Driver "synaptics"
        ${lib.optionalString (cfg.minSpeed != null) ''Option "MinSpeed" "${cfg.minSpeed}"''}
        ${lib.optionalString (cfg.maxSpeed != null) ''Option "MaxSpeed" "${cfg.maxSpeed}"''}
        ${lib.optionalString (cfg.accelFactor != null) ''Option "AccelFactor" "${cfg.accelFactor}"''}
        ${lib.optionalString cfg.tapButtons tapConfig}
        Option "ClickFinger1" "${builtins.elemAt cfg.buttonsMap 0}"
        Option "ClickFinger2" "${builtins.elemAt cfg.buttonsMap 1}"
        Option "ClickFinger3" "${builtins.elemAt cfg.buttonsMap 2}"
        Option "VertTwoFingerScroll" "${if cfg.vertTwoFingerScroll then "1" else "0"}"
        Option "HorizTwoFingerScroll" "${if cfg.horizTwoFingerScroll then "1" else "0"}"
        Option "VertEdgeScroll" "${if cfg.vertEdgeScroll then "1" else "0"}"
        Option "HorizEdgeScroll" "${if cfg.horizEdgeScroll then "1" else "0"}"
        ${lib.optionalString cfg.palmDetect ''Option "PalmDetect" "1"''}
        ${lib.optionalString (
          cfg.palmMinWidth != null
        ) ''Option "PalmMinWidth" "${toString cfg.palmMinWidth}"''}
        ${lib.optionalString (cfg.palmMinZ != null) ''Option "PalmMinZ" "${toString cfg.palmMinZ}"''}
        ${lib.optionalString (
          cfg.scrollDelta != null
        ) ''Option "VertScrollDelta" "${toString cfg.scrollDelta}"''}
        ${
          if !cfg.horizontalScroll then
            ''Option "HorizScrollDelta" "0"''
          else
            (lib.optionalString (
              cfg.scrollDelta != null
            ) ''Option "HorizScrollDelta" "${toString cfg.scrollDelta}"'')
        }
        ${cfg.additionalOptions}
      EndSection
    '';

    assertions = [
      {
        assertion = !config.services.libinput.enable;
        message = "Synaptics and libinput are incompatible, you cannot enable both.";
      }
    ];

  };

}
