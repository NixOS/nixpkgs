{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.services.xserver.synaptics; in

{

  options = {

    services.xserver.synaptics = {

      enable = mkOption {
        default = false;
        example = true;
        description = "Whether to enable touchpad support.";
      };

      dev = mkOption {
        default = null;
        example = "/dev/input/event0";
        description =
          ''
            Path for touchpad device.  Set to null to apply to any
            auto-detected touchpad.
          '';
      };

      accelFactor = mkOption {
        default = "0.001";
        description = "Cursor acceleration (how fast speed increases from minSpeed to maxSpeed).";
      };

      minSpeed = mkOption {
        default = "0.6";
        description = "Cursor speed factor for precision finger motion.";
      };

      maxSpeed = mkOption {
        default = "1.0";
        description = "Cursor speed factor for highest-speed finger motion.";
      };

      twoFingerScroll = mkOption {
        default = false;
        description = "Whether to enable two-finger drag-scrolling.";
      };

      vertEdgeScroll = mkOption {
        default = ! cfg.twoFingerScroll;
        description = "Whether to enable vertical edge drag-scrolling.";
      };

      tapButtons = mkOption {
        default = true;
        example = false;
        description = "Whether to enable tap buttons.";
      };

      buttonsMap = mkOption {
        default = [1 2 3];
        example = [1 3 2];
        description = "Remap touchpad buttons.";
        apply = map toString;
      };

      palmDetect = mkOption {
        default = false;
        example = true;
        description = "Whether to enable palm detection (hardware support required)";
      };

      horizontalScroll = mkOption {
        default = true;
        example = false;
        description = "Whether to enable horizontal scrolling (on touchpad)";
      };

      additionalOptions = mkOption {
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

    services.xserver.modules = [ pkgs.xorg.xf86inputsynaptics ];

    environment.systemPackages = [ pkgs.xorg.xf86inputsynaptics ];

    services.xserver.config =
      ''
        # Automatically enable the synaptics driver for all touchpads.
        Section "InputClass"
          Identifier "synaptics touchpad catchall"
          MatchIsTouchpad "on"
          ${optionalString (cfg.dev != null) ''MatchDevicePath "${cfg.dev}"''}
          Driver "synaptics"
          Option "MaxTapTime" "180"
          Option "MaxTapMove" "220"
          Option "MinSpeed" "${cfg.minSpeed}"
          Option "MaxSpeed" "${cfg.maxSpeed}"
          Option "AccelFactor" "${cfg.accelFactor}"
          ${if cfg.tapButtons then "" else ''Option "MaxTapTime" "0"''}
          Option "TapButton1" "${builtins.elemAt cfg.buttonsMap 0}"
          Option "TapButton2" "${builtins.elemAt cfg.buttonsMap 1}"
          Option "TapButton3" "${builtins.elemAt cfg.buttonsMap 2}"
          Option "ClickFinger1" "${builtins.elemAt cfg.buttonsMap 0}"
          Option "ClickFinger2" "${builtins.elemAt cfg.buttonsMap 1}"
          Option "ClickFinger3" "${builtins.elemAt cfg.buttonsMap 2}"
          Option "VertTwoFingerScroll" "${if cfg.twoFingerScroll then "1" else "0"}"
          Option "HorizTwoFingerScroll" "${if cfg.twoFingerScroll then "1" else "0"}"
          Option "VertEdgeScroll" "${if cfg.vertEdgeScroll then "1" else "0"}"
          ${if cfg.palmDetect then ''Option "PalmDetect" "1"'' else ""}
          ${if cfg.horizontalScroll then "" else ''Option "HorizScrollDelta" "0"''}
          ${cfg.additionalOptions}
        EndSection
      '';

  };

}
