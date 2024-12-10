{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.libinput;

  xorgBool = v: if v then "on" else "off";

  mkConfigForDevice = deviceType: {
    dev = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/dev/input/event0";
      description = ''
        Path for ${deviceType} device.  Set to `null` to apply to any
        auto-detected ${deviceType}.
      '';
    };

    accelProfile = mkOption {
      type = types.enum [
        "flat"
        "adaptive"
      ];
      default = "adaptive";
      example = "flat";
      description = ''
        Sets the pointer acceleration profile to the given profile.
        Permitted values are `adaptive`, `flat`.
        Not all devices support this option or all profiles.
        If a profile is unsupported, the default profile for this is used.
        `flat`: Pointer motion is accelerated by a constant
        (device-specific) factor, depending on the current speed.
        `adaptive`: Pointer acceleration depends on the input speed.
        This is the default profile for most devices.
      '';
    };

    accelSpeed = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "-0.5";
      description = "Cursor acceleration (how fast speed increases from minSpeed to maxSpeed).";
    };

    buttonMapping = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "1 6 3 4 5 0 7";
      description = ''
        Sets the logical button mapping for this device, see XSetPointerMapping(3). The string  must
        be  a  space-separated  list  of  button mappings in the order of the logical buttons on the
        device, starting with button 1.  The default mapping is "1 2 3 ... 32". A mapping of 0 deac‐
        tivates the button. Multiple buttons can have the same mapping.  Invalid mapping strings are
        discarded and the default mapping is used for all buttons.  Buttons  not  specified  in  the
        user's mapping use the default mapping. See section BUTTON MAPPING for more details.
      '';
    };

    calibrationMatrix = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "0.5 0 0 0 0.8 0.1 0 0 1";
      description = ''
        A string of 9 space-separated floating point numbers. Sets the calibration matrix to the
        3x3 matrix where the first row is (abc), the second row is (def) and the third row is (ghi).
      '';
    };

    clickMethod = mkOption {
      type = types.nullOr (
        types.enum [
          "none"
          "buttonareas"
          "clickfinger"
        ]
      );
      default = null;
      example = "buttonareas";
      description = ''
        Enables a click method. Permitted values are `none`,
        `buttonareas`, `clickfinger`.
        Not all devices support all methods, if an option is unsupported,
        the default click method for this device is used.
      '';
    };

    leftHanded = mkOption {
      type = types.bool;
      default = false;
      description = "Enables left-handed button orientation, i.e. swapping left and right buttons.";
    };

    middleEmulation = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enables middle button emulation. When enabled, pressing the left and right buttons
        simultaneously produces a middle mouse button click.
      '';
    };

    naturalScrolling = mkOption {
      type = types.bool;
      default = false;
      description = "Enables or disables natural scrolling behavior.";
    };

    scrollButton = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 1;
      description = ''
        Designates a button as scroll button. If the ScrollMethod is button and the button is logically
        held down, x/y axis movement is converted into scroll events.
      '';
    };

    scrollMethod = mkOption {
      type = types.enum [
        "twofinger"
        "edge"
        "button"
        "none"
      ];
      default = "twofinger";
      example = "edge";
      description = ''
        Specify the scrolling method: `twofinger`, `edge`,
        `button`, or `none`
      '';
    };

    horizontalScrolling = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enables or disables horizontal scrolling. When disabled, this driver will discard any
        horizontal scroll events from libinput. This does not disable horizontal scroll events
        from libinput; it merely discards the horizontal axis from any scroll events.
      '';
    };

    sendEventsMode = mkOption {
      type = types.enum [
        "disabled"
        "enabled"
        "disabled-on-external-mouse"
      ];
      default = "enabled";
      example = "disabled";
      description = ''
        Sets the send events mode to `disabled`, `enabled`,
        or `disabled-on-external-mouse`
      '';
    };

    tapping = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enables or disables tap-to-click behavior.
      '';
    };

    tappingButtonMap = mkOption {
      type = types.nullOr (
        types.enum [
          "lrm"
          "lmr"
        ]
      );
      default = null;
      description = ''
        Set the button mapping for 1/2/3-finger taps to left/right/middle or left/middle/right, respectively.
      '';
    };

    tappingDragLock = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enables or disables drag lock during tapping behavior. When enabled, a finger up during tap-
        and-drag will not immediately release the button. If the finger is set down again within the
        timeout, the dragging process continues.
      '';
    };

    transformationMatrix = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "0.5 0 0 0 0.8 0.1 0 0 1";
      description = ''
        A string of 9 space-separated floating point numbers. Sets the transformation matrix to
        the 3x3 matrix where the first row is (abc), the second row is (def) and the third row is (ghi).
      '';
    };

    disableWhileTyping = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disable input method while typing.
      '';
    };

    additionalOptions = mkOption {
      type = types.lines;
      default = "";
      example = ''
        Option "DragLockButtons" "L1 B1 L2 B2"
      '';
      description = ''
        Additional options for libinput ${deviceType} driver. See
        {manpage}`libinput(4)`
        for available options.";
      '';
    };
  };

  mkX11ConfigForDevice = deviceType: matchIs: ''
    Identifier "libinput ${deviceType} configuration"
    MatchDriver "libinput"
    MatchIs${matchIs} "${xorgBool true}"
    ${optionalString (cfg.${deviceType}.dev != null) ''MatchDevicePath "${cfg.${deviceType}.dev}"''}
    Option "AccelProfile" "${cfg.${deviceType}.accelProfile}"
    ${optionalString (
      cfg.${deviceType}.accelSpeed != null
    ) ''Option "AccelSpeed" "${cfg.${deviceType}.accelSpeed}"''}
    ${optionalString (cfg.${deviceType}.buttonMapping != null)
      ''Option "ButtonMapping" "${cfg.${deviceType}.buttonMapping}"''
    }
    ${optionalString (cfg.${deviceType}.calibrationMatrix != null)
      ''Option "CalibrationMatrix" "${cfg.${deviceType}.calibrationMatrix}"''
    }
    ${optionalString (
      cfg.${deviceType}.transformationMatrix != null
    ) ''Option "TransformationMatrix" "${cfg.${deviceType}.transformationMatrix}"''}
    ${optionalString (
      cfg.${deviceType}.clickMethod != null
    ) ''Option "ClickMethod" "${cfg.${deviceType}.clickMethod}"''}
    Option "LeftHanded" "${xorgBool cfg.${deviceType}.leftHanded}"
    Option "MiddleEmulation" "${xorgBool cfg.${deviceType}.middleEmulation}"
    Option "NaturalScrolling" "${xorgBool cfg.${deviceType}.naturalScrolling}"
    ${optionalString (cfg.${deviceType}.scrollButton != null)
      ''Option "ScrollButton" "${toString cfg.${deviceType}.scrollButton}"''
    }
    Option "ScrollMethod" "${cfg.${deviceType}.scrollMethod}"
    Option "HorizontalScrolling" "${xorgBool cfg.${deviceType}.horizontalScrolling}"
    Option "SendEventsMode" "${cfg.${deviceType}.sendEventsMode}"
    Option "Tapping" "${xorgBool cfg.${deviceType}.tapping}"
    ${optionalString (cfg.${deviceType}.tappingButtonMap != null)
      ''Option "TappingButtonMap" "${cfg.${deviceType}.tappingButtonMap}"''
    }
    Option "TappingDragLock" "${xorgBool cfg.${deviceType}.tappingDragLock}"
    Option "DisableWhileTyping" "${xorgBool cfg.${deviceType}.disableWhileTyping}"
    ${cfg.${deviceType}.additionalOptions}
  '';
in
{

  imports =
    (map
      (
        option:
        mkRenamedOptionModule
          ([
            "services"
            "xserver"
            "libinput"
            option
          ])
          [
            "services"
            "libinput"
            "touchpad"
            option
          ]
      )
      [
        "accelProfile"
        "accelSpeed"
        "buttonMapping"
        "calibrationMatrix"
        "clickMethod"
        "leftHanded"
        "middleEmulation"
        "naturalScrolling"
        "scrollButton"
        "scrollMethod"
        "horizontalScrolling"
        "sendEventsMode"
        "tapping"
        "tappingButtonMap"
        "tappingDragLock"
        "transformationMatrix"
        "disableWhileTyping"
        "additionalOptions"
      ]
    )
    ++ [
      (mkRenamedOptionModule
        [ "services" "xserver" "libinput" "enable" ]
        [ "services" "libinput" "enable" ]
      )
      (mkRenamedOptionModule
        [ "services" "xserver" "libinput" "mouse" ]
        [ "services" "libinput" "mouse" ]
      )
      (mkRenamedOptionModule
        [ "services" "xserver" "libinput" "touchpad" ]
        [ "services" "libinput" "touchpad" ]
      )
    ];

  options = {

    services.libinput = {
      enable = mkEnableOption "libinput" // {
        default = config.services.xserver.enable;
        defaultText = lib.literalExpression "config.services.xserver.enable";
      };
      mouse = mkConfigForDevice "mouse";
      touchpad = mkConfigForDevice "touchpad";
    };
  };

  config = mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xorg.xf86inputlibinput ];

    environment.systemPackages = [ pkgs.xorg.xf86inputlibinput ];

    environment.etc =
      let
        cfgPath = "X11/xorg.conf.d/40-libinput.conf";
      in
      {
        ${cfgPath} = {
          source = pkgs.xorg.xf86inputlibinput.out + "/share/" + cfgPath;
        };
      };

    services.udev.packages = [ pkgs.libinput.out ];

    services.xserver.inputClassSections = [
      (mkX11ConfigForDevice "mouse" "Pointer")
      (mkX11ConfigForDevice "touchpad" "Touchpad")
    ];

    assertions = [
      # already present in synaptics.nix
      /*
        {
          assertion = !config.services.xserver.synaptics.enable;
          message = "Synaptics and libinput are incompatible, you cannot enable both (in services.xserver).";
        }
      */
    ];

  };

}
