{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {

    hardware.trackpoint = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable sensitivity and speed configuration for trackpoints.
        '';
      };
  
      sensitivity = mkOption {
        default = 128;
        example = 255;
        type = types.int;
        description = ''
          Configure the trackpoint sensitivity. By default, the kernel
          configures 128.
        '';
      };

      speed = mkOption {
        default = 97;
        example = 255;
        type = types.int;
        description = ''
          Configure the trackpoint sensitivity. By default, the kernel
          configures 97.
        '';
      };

      emulateWheel = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable scrolling while holding the middle mouse button.
        '';
      };
      
    };

  };


  ###### implementation

  config = mkMerge [
    (mkIf config.hardware.trackpoint.enable {
      services.udev.extraRules =
      ''
        ACTION=="add|change", SUBSYSTEM=="input", ATTR{name}=="TPPS/2 IBM TrackPoint", ATTR{device/speed}="${toString config.hardware.trackpoint.speed}", ATTR{device/sensitivity}="${toString config.hardware.trackpoint.sensitivity}"
      '';

      system.activationScripts.trackpoint =
        ''
          ${config.systemd.package}/bin/udevadm trigger --attr-match=name="TPPS/2 IBM TrackPoint"
        '';
    })

    (mkIf config.hardware.trackpoint.emulateWheel {
      services.xserver.config =
        ''
          Section "InputClass"
            Identifier "Trackpoint Wheel Emulation"
            MatchProduct "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint"
            MatchDevicePath "/dev/input/event*"
            Option "EmulateWheel" "true"
            Option "EmulateWheelButton" "2"
            Option "Emulate3Buttons" "false"
            Option "XAxisMapping" "6 7"
            Option "YAxisMapping" "4 5"
            EndSection
        '';
    })
  ];
}
