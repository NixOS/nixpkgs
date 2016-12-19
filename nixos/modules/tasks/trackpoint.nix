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
          Configure the trackpoint speed. By default, the kernel
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

      fakeButtons = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Switch to "bare" PS/2 mouse support in case Trackpoint buttons are not recognized
          properly. This can happen for example on models like the L430, T450, T450s, on
          which the Trackpoint buttons are actually a part of the Synaptics touchpad.
        '';
      };

    };

  };


  ###### implementation

  config =
  let cfg = config.hardware.trackpoint; in
  mkMerge [
    (mkIf cfg.enable {
      services.udev.extraRules =
      ''
        ACTION=="add|change", SUBSYSTEM=="input", ATTR{name}=="TPPS/2 IBM TrackPoint", ATTR{device/speed}="${toString cfg.speed}", ATTR{device/sensitivity}="${toString cfg.sensitivity}"
      '';

      system.activationScripts.trackpoint =
        ''
          ${config.systemd.package}/bin/udevadm trigger --attr-match=name="TPPS/2 IBM TrackPoint"
        '';
    })

    (mkIf (cfg.emulateWheel) {
      services.xserver.inputClassSections =
        [''
        Identifier "Trackpoint Wheel Emulation"
          MatchProduct "${if cfg.fakeButtons then "PS/2 Generic Mouse" else "Elantech PS/2 TrackPoint|TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint"}"
          MatchDevicePath "/dev/input/event*"
          Option "EmulateWheel" "true"
          Option "EmulateWheelButton" "2"
          Option "Emulate3Buttons" "false"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
        ''];
    })

    (mkIf cfg.fakeButtons {
      boot.extraModprobeConfig = "options psmouse proto=bare";
    })
  ];
}
