{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.synaptics;
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
in {

  options = {

    services.xserver.synaptics = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable touchpad support.";
      };

      dev = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/dev/input/event0";
        description =
          ''
            Path for touchpad device.  Set to null to apply to any
            auto-detected touchpad.
          '';
      };

      accelFactor = mkOption {
        type = types.nullOr types.string;
        default = "0.001";
        description = "Cursor acceleration (how fast speed increases from minSpeed to maxSpeed).";
      };

      minSpeed = mkOption {
        type = types.nullOr types.string;
        default = "0.6";
        description = "Cursor speed factor for precision finger motion.";
      };

      maxSpeed = mkOption {
        type = types.nullOr types.string;
        default = "1.0";
        description = "Cursor speed factor for highest-speed finger motion.";
      };

      scrollDelta = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 75;
        description = "Move distance of the finger for a scroll event.";
      };

      twoFingerScroll = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable two-finger drag-scrolling. Overridden by horizTwoFingerScroll and vertTwoFingerScroll.";
      };

      horizTwoFingerScroll = mkOption {
        type = types.bool;
        default = cfg.twoFingerScroll;
        description = "Whether to enable horizontal two-finger drag-scrolling.";
      };

      vertTwoFingerScroll = mkOption {
        type = types.bool;
        default = cfg.twoFingerScroll;
        description = "Whether to enable vertical two-finger drag-scrolling.";
      };

      horizEdgeScroll = mkOption {
        type = types.bool;
        default = ! cfg.horizTwoFingerScroll;
        description = "Whether to enable horizontal edge drag-scrolling.";
      };

      vertEdgeScroll = mkOption {
        type = types.bool;
        default = ! cfg.vertTwoFingerScroll;
        description = "Whether to enable vertical edge drag-scrolling.";
      };

      tapButtons = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable tap buttons.";
      };

      buttonsMap = mkOption {
        type = types.listOf types.int;
        default = [1 2 3];
        example = [1 3 2];
        description = "Remap touchpad buttons.";
        apply = map toString;
      };

      fingersMap = mkOption {
        type = types.listOf types.int;
        default = [1 2 3];
        example = [1 3 2];
        description = "Remap several-fingers taps.";
        apply = map toString;
      };

      palmDetect = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable palm detection (hardware support required)";
      };

      palmMinWidth = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 5;
        description = "Minimum finger width at which touch is considered a palm";
      };

      palmMinZ = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 20;
        description = "Minimum finger pressure at which touch is considered a palm";
      };

      horizontalScroll = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable horizontal scrolling (on touchpad)";
      };

      additionalOptions = mkOption {
        type = types.str;
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


  config = mkIf cfg.enable {

    services.xserver.modules = [ pkg.out ];

    environment.etc."${etcFile}".source =
      "${pkg.out}/share/X11/xorg.conf.d/70-synaptics.conf";

    environment.systemPackages = [ pkg ];

    services.xserver.config =
      ''
        # Automatically enable the synaptics driver for all touchpads.
        Section "InputClass"
          Identifier "synaptics touchpad catchall"
          MatchIsTouchpad "on"
          ${optionalString (cfg.dev != null) ''MatchDevicePath "${cfg.dev}"''}
          Driver "synaptics"
          ${optionalString (cfg.minSpeed != null) ''Option "MinSpeed" "${cfg.minSpeed}"''}
          ${optionalString (cfg.maxSpeed != null) ''Option "MaxSpeed" "${cfg.maxSpeed}"''}
          ${optionalString (cfg.accelFactor != null) ''Option "AccelFactor" "${cfg.accelFactor}"''}
          ${optionalString cfg.tapButtons tapConfig}
          Option "ClickFinger1" "${builtins.elemAt cfg.buttonsMap 0}"
          Option "ClickFinger2" "${builtins.elemAt cfg.buttonsMap 1}"
          Option "ClickFinger3" "${builtins.elemAt cfg.buttonsMap 2}"
          Option "VertTwoFingerScroll" "${if cfg.vertTwoFingerScroll then "1" else "0"}"
          Option "HorizTwoFingerScroll" "${if cfg.horizTwoFingerScroll then "1" else "0"}"
          Option "VertEdgeScroll" "${if cfg.vertEdgeScroll then "1" else "0"}"
          Option "HorizEdgeScroll" "${if cfg.horizEdgeScroll then "1" else "0"}"
          ${optionalString cfg.palmDetect ''Option "PalmDetect" "1"''}
          ${optionalString (cfg.palmMinWidth != null) ''Option "PalmMinWidth" "${toString cfg.palmMinWidth}"''}
          ${optionalString (cfg.palmMinZ != null) ''Option "PalmMinZ" "${toString cfg.palmMinZ}"''}
          ${optionalString (cfg.scrollDelta != null) ''Option "VertScrollDelta" "${toString cfg.scrollDelta}"''}
          ${if !cfg.horizontalScroll then ''Option "HorizScrollDelta" "0"''
            else (optionalString (cfg.scrollDelta != null) ''Option "HorizScrollDelta" "${toString cfg.scrollDelta}"'')}
          ${cfg.additionalOptions}
        EndSection
      '';

    assertions = [
      {
        assertion = !config.services.xserver.libinput.enable;
        message = "Synaptics and libinput are incompatible, you cannot enable both (in services.xserver).";
      }
    ];

  };

}
