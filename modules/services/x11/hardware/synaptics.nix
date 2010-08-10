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
        default = true;
        description = "Whether to enable vertical edge drag-scrolling.";
      };

    };

  };


  config = mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xorg.xf86inputsynaptics ];

    services.xserver.config =
      ''
        # Automatically enable the synaptics driver for all touchpads.
        Section "InputClass"
          Identifier "touchpad catchall"
          Driver "synaptics"
          MatchIsTouchpad "on"
          ${optionalString (cfg.dev != null) ''MatchDevicePath "${cfg.dev}"''}
          Option "MaxTapTime" "180"
          Option "MaxTapMove" "220"
          Option "MinSpeed" "${cfg.minSpeed}"
          Option "MaxSpeed" "${cfg.maxSpeed}"
          Option "AccelFactor" "0.0010"
          Option "TapButton1" "1"
          Option "TapButton2" "2"
          Option "TapButton3" "3"
          Option "VertTwoFingerScroll" "${if cfg.twoFingerScroll then "1" else "0"}"
          Option "HorizTwoFingerScroll" "${if cfg.twoFingerScroll then "1" else "0"}"
          Option "VertEdgeScroll" "${if cfg.vertEdgeScroll then "1" else "0"}"
        EndSection
      '';

  };

}
