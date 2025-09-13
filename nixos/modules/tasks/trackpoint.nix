{
  config,
  lib,
  ...
}:
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
          Trackpoint sensitivity.
        '';
      };

      inertia = mkOption {
        default = 6;
        example = 10;
        type = types.int;
        description = ''
          Negative inertia factor. High values cause the cursor to snap backward when the trackpoint is released.
        '';
      };

      reach = mkOption {
        default = 10;
        example = 20;
        type = types.int;
        description = ''
          Backup range for z-axis press.
        '';
      };

      draghys = mkOption {
        default = 255;
        example = 200;
        type = types.int;
        description = ''
          The drag hysteresis controls how hard it is to drag with z-axis pressed.
        '';
      };

      mindrag = mkOption {
        default = 20;
        example = 30;
        type = types.int;
        description = ''
          Minimum amount of force needed to trigger dragging.
        '';
      };

      speed = mkOption {
        default = 97;
        example = 255;
        type = types.int;
        description = ''
          Speed of the trackpoint cursor.
        '';
      };

      thresh = mkOption {
        default = 8;
        example = 10;
        type = types.int;
        description = ''
          Minimum value for z-axis force required to trigger a press or release, relative to the running average.
        '';
      };

      upthresh = mkOption {
        default = 255;
        example = 250;
        type = types.int;
        description = ''
          The offset from the running average required to generate a select (click) on z-axis on release.
        '';
      };

      ztime = mkOption {
        default = 38;
        example = 50;
        type = types.int;
        description = ''
          This attribute determines how sharp a press has to be in order to be recognized.
        '';
      };

      jenks = mkOption {
        default = 135;
        example = 100;
        type = types.int;
        description = ''
          Minimum curvature in degrees required to generate a double click without a release.
        '';
      };

      skipback = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = ''
          When the skipback bit is set, backup cursor movement during releases from drags will be suppressed. The default value for this bit is 0.
        '';
      };

      ext_dev = mkOption {
        default = true;
        example = false;
        type = types.bool;
        description = ''
          Disable or enable external pointing device.
        '';
      };

      press_to_select = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = ''
          Setting this to true will enable the Press to Select functions like tapping the control stick to simulate a left click, and setting false will disable it.
        '';
      };

      drift_time = mkOption {
        default = 5;
        example = 100;
        type = types.int;
        description = ''
                  This parameter controls the period of time to test for a 'hands off' condition (i.e. when no force is applied) before a drift (noise) calibration occurs.

          IBM Trackpoints have a feature to compensate for drift by recalibrating themselves periodically. By default, if for 0.5 seconds there is no change in position, it's used as the new zero. This duration is too low. Often, the calibration happens when the trackpoint is in fact being used.
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

      device = mkOption {
        default = "TPPS/2 IBM TrackPoint";
        type = types.str;
        description = ''
          The device name of the trackpoint. You can check with xinput.
          Some newer devices (example x1c6) use "TPPS/2 Elan TrackPoint".
        '';
      };
    };
  };

  ###### implementation

  config =
    let
      cfg = config.hardware.trackpoint;
      boolToStr = val: if val then "1" else "0";
    in
    mkMerge [
      (mkIf cfg.enable {
        services.udev.extraRules = (
          builtins.concatStringsSep ", " [
            "ACTION==\"add|change\""
            "SUBSYSTEM==\"input\""
            "ATTR{name}==\"${cfg.device}\""
            "ATTR{device/sensitivity}=\"${toString cfg.sensitivity}\""
            "ATTR{device/inertia}=\"${toString cfg.inertia}\""
            "ATTR{device/reach}=\"${toString cfg.reach}\""
            "ATTR{device/draghys}=\"${toString cfg.draghys}\""
            "ATTR{device/mindrag}=\"${toString cfg.mindrag}\""
            "ATTR{device/speed}=\"${toString cfg.speed}\""
            "ATTR{device/thresh}=\"${toString cfg.thresh}\""
            "ATTR{device/upthresh}=\"${toString cfg.upthresh}\""
            "ATTR{device/ztime}=\"${toString cfg.ztime}\""
            "ATTR{device/jenks}=\"${toString cfg.jenks}\""
            "ATTR{device/skipback}=\"${boolToStr cfg.skipback}\""
            "ATTR{device/ext_dev}=\"${boolToStr cfg.ext_dev}\""
            "ATTR{device/press_to_select}=\"${boolToStr cfg.press_to_select}\""
            "ATTR{device/drift_time}=\"${toString cfg.drift_time}\""
          ]
        );

        systemd.services.trackpoint = {
          wantedBy = [ "sysinit.target" ];
          before = [
            "sysinit.target"
            "shutdown.target"
          ];
          conflicts = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          serviceConfig.RemainAfterExit = true;
          serviceConfig.ExecStart = ''
            ${config.systemd.package}/bin/udevadm trigger --attr-match=name="${cfg.device}"
          '';
        };
      })

      (mkIf (cfg.emulateWheel) {
        services.xserver.inputClassSections = [
          ''
            Identifier "Trackpoint Wheel Emulation"
            MatchProduct "${
              if cfg.fakeButtons then
                "PS/2 Generic Mouse"
              else
                "ETPS/2 Elantech TrackPoint|Elantech PS/2 TrackPoint|TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint|${cfg.device}"
            }"
            MatchDevicePath "/dev/input/event*"
            Option "EmulateWheel" "true"
            Option "EmulateWheelButton" "2"
            Option "Emulate3Buttons" "false"
            Option "XAxisMapping" "6 7"
            Option "YAxisMapping" "4 5"
          ''
        ];
      })

      (mkIf cfg.fakeButtons {
        boot.extraModprobeConfig = "options psmouse proto=bare";
      })
    ];
}
