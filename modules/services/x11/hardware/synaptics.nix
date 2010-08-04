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
        default = "/dev/input/event0";
	example = null;
        description = "Event device for Synaptics touchpad, null to omit specification.";
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
        Section "InputDevice"
          Identifier "Touchpad[0]"
          Driver "synaptics"
          ${if cfg.dev != null then ''Option "Device" "${cfg.dev}"'' else ""}
          Option "Protocol" "PS/2"
          Option "LeftEdge" "1700"
          Option "RightEdge" "5300"
          Option "TopEdge" "1700"
          Option "BottomEdge" "4200"
          Option "FingerLow" "25"
          Option "FingerHigh" "30"
          Option "MaxTapTime" "180"
          Option "MaxTapMove" "220"
          Option "VertScrollDelta" "100"
          Option "MinSpeed" "${cfg.minSpeed}"
          Option "MaxSpeed" "${cfg.maxSpeed}"
          Option "AccelFactor" "0.0010"
          Option "SHMConfig" "on"
          Option "Repeater" "/dev/input/mice"
          Option "TapButton1" "1"
          Option "TapButton2" "2"
          Option "TapButton3" "3"
          Option "VertTwoFingerScroll" "${if cfg.twoFingerScroll then "1" else "0"}"
          Option "HorizTwoFingerScroll" "${if cfg.twoFingerScroll then "1" else "0"}"
          Option "VertEdgeScroll" "${if cfg.vertEdgeScroll then "1" else "0"}"
        EndSection
      '';

    services.xserver.serverLayoutSection =
      ''
        InputDevice "Touchpad[0]" "CorePointer"
      '';

  };

}
