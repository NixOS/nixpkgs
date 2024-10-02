{ config, lib, pkgs, ... }:
let cfg = config.services.libinput;

    xorgBool = v: if v then "on" else "off";

    mkConfigForDevice = deviceType: {
      dev = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/dev/input/event0";
        description = ''
            Path for ${deviceType} device.  Set to `null` to apply to any
            auto-detected ${deviceType}.
          '';
      };

      accelProfile = lib.mkOption {
        type = lib.types.enum [ "flat" "adaptive" "custom" ];
        default = "adaptive";
        example = "flat";
        description = ''
            Sets the pointer acceleration profile to the given profile.
            Permitted values are `adaptive`, `flat`, `custom`.
            Not all devices support this option or all profiles.
            If a profile is unsupported, the default profile for this is used.
            `flat`: Pointer motion is accelerated by a constant
            (device-specific) factor, depending on the current speed.
            `adaptive`: Pointer acceleration depends on the input speed.
            This is the default profile for most devices.
            `custom`: Allows the user to define a custom acceleration function.
            To define custom functions use the accelPoints<Fallback/Motion/Scroll>
            and accelStep<Fallback/Motion/Scroll> options.
          '';
      };

      accelSpeed = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "-0.5";
        description = ''
            Cursor acceleration (how fast speed increases from minSpeed to maxSpeed).
            This only applies to the flat or adaptive profile.
          '';
      };

      accelPointsFallback = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.number);
        default = null;
        example = [ 0.0 1.0 2.4 2.5 ];
        description = ''
            Sets the points of the fallback acceleration function. The value must be a list of
            floating point non-negative numbers. This only applies to the custom profile.
          '';
      };

      accelPointsMotion = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.number);
        default = null;
        example = [ 0.0 1.0 2.4 2.5 ];
        description = ''
            Sets the points of the (pointer) motion acceleration function. The value must be a
            list of floating point non-negative numbers. This only applies to the custom profile.
          '';
      };

      accelPointsScroll = lib.mkOption {
        type = lib.types.nullOr (lib.types.listOf lib.types.number);
        default = null;
        example = [ 0.0 1.0 2.4 2.5 ];
        description = ''
            Sets the points of the scroll acceleration function. The value must be a list of
            floating point non-negative numbers. This only applies to the custom profile.
          '';
      };

      accelStepFallback = lib.mkOption {
        type = lib.types.nullOr lib.types.number;
        default = null;
        example = 0.1;
        description = ''
            Sets the step between the points of the fallback acceleration function. When a step of
            0.0 is provided, libinput's Fallback acceleration function is used. This only applies
            to the custom profile.
          '';
      };

      accelStepMotion = lib.mkOption {
        type = lib.types.nullOr lib.types.number;
        default = null;
        example = 0.1;
        description = ''
            Sets the step between the points of the (pointer) motion acceleration function. When a
            step of 0.0 is provided, libinput's Fallback acceleration function is used. This only
            applies to the custom profile.
          '';
      };

      accelStepScroll = lib.mkOption {
        type = lib.types.nullOr lib.types.number;
        default = null;
        example = 0.1;
        description = ''
            Sets the step between the points of the scroll acceleration function. When a step of
            0.0 is provided, libinput's Fallback acceleration function is used. This only applies
            to the custom profile.
          '';
      };

      buttonMapping = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
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

      calibrationMatrix = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "0.5 0 0 0 0.8 0.1 0 0 1";
        description = ''
            A string of 9 space-separated floating point numbers. Sets the calibration matrix to the
            3x3 matrix where the first row is (abc), the second row is (def) and the third row is (ghi).
          '';
      };

      clickMethod = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "none" "buttonareas" "clickfinger" ]);
        default = null;
        example = "buttonareas";
        description = ''
            Enables a click method. Permitted values are `none`,
            `buttonareas`, `clickfinger`.
            Not all devices support all methods, if an option is unsupported,
            the default click method for this device is used.
          '';
      };

      leftHanded = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables left-handed button orientation, i.e. swapping left and right buttons.";
      };

      middleEmulation = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
            Enables middle button emulation. When enabled, pressing the left and right buttons
            simultaneously produces a middle mouse button click.
          '';
      };

      naturalScrolling = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enables or disables natural scrolling behavior.";
      };

      scrollButton = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        example = 1;
        description = ''
            Designates a button as scroll button. If the ScrollMethod is button and the button is logically
            held down, x/y axis movement is converted into scroll events.
          '';
      };

      scrollMethod = lib.mkOption {
        type = lib.types.enum [ "twofinger" "edge" "button" "none" ];
        default = "twofinger";
        example = "edge";
        description = ''
            Specify the scrolling method: `twofinger`, `edge`,
            `button`, or `none`
          '';
      };

      horizontalScrolling = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
            Enables or disables horizontal scrolling. When disabled, this driver will discard any
            horizontal scroll events from libinput. This does not disable horizontal scroll events
            from libinput; it merely discards the horizontal axis from any scroll events.
          '';
      };

      sendEventsMode = lib.mkOption {
        type = lib.types.enum [ "disabled" "enabled" "disabled-on-external-mouse" ];
        default = "enabled";
        example = "disabled";
        description = ''
            Sets the send events mode to `disabled`, `enabled`,
            or `disabled-on-external-mouse`
          '';
      };

      tapping = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
            Enables or disables tap-to-click behavior.
          '';
      };

      tappingButtonMap = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "lrm" "lmr" ]);
        default = null;
        description = ''
          Set the button mapping for 1/2/3-finger taps to left/right/middle or left/middle/right, respectively.
        '';
      };

      tappingDragLock = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
            Enables or disables drag lock during tapping behavior. When enabled, a finger up during tap-
            and-drag will not immediately release the button. If the finger is set down again within the
            timeout, the dragging process continues.
          '';
      };

      transformationMatrix = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "0.5 0 0 0 0.8 0.1 0 0 1";
        description = ''
          A string of 9 space-separated floating point numbers. Sets the transformation matrix to
          the 3x3 matrix where the first row is (abc), the second row is (def) and the third row is (ghi).
        '';
      };

      disableWhileTyping = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
            Disable input method while typing.
          '';
      };

      additionalOptions = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example =
        ''
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
      ${lib.optionalString (cfg.${deviceType}.dev != null) ''MatchDevicePath "${cfg.${deviceType}.dev}"''}
      Option "AccelProfile" "${cfg.${deviceType}.accelProfile}"
      ${lib.optionalString (cfg.${deviceType}.accelSpeed != null) ''Option "AccelSpeed" "${cfg.${deviceType}.accelSpeed}"''}
      ${lib.optionalString (cfg.${deviceType}.accelPointsFallback != null) ''Option "AccelPointsFallback" "${toString cfg.${deviceType}.accelPointsFallback}"''}
      ${lib.optionalString (cfg.${deviceType}.accelPointsMotion != null) ''Option "AccelPointsMotion" "${toString cfg.${deviceType}.accelPointsMotion}"''}
      ${lib.optionalString (cfg.${deviceType}.accelPointsScroll != null) ''Option "AccelPointsScroll" "${toString cfg.${deviceType}.accelPointsScroll}"''}
      ${lib.optionalString (cfg.${deviceType}.accelStepFallback != null) ''Option "AccelStepFallback" "${toString cfg.${deviceType}.accelStepFallback}"''}
      ${lib.optionalString (cfg.${deviceType}.accelStepMotion != null) ''Option "AccelStepMotion" "${toString cfg.${deviceType}.accelStepMotion}"''}
      ${lib.optionalString (cfg.${deviceType}.accelStepScroll != null) ''Option "AccelStepScroll" "${toString cfg.${deviceType}.accelStepScroll}"''}
      ${lib.optionalString (cfg.${deviceType}.buttonMapping != null) ''Option "ButtonMapping" "${cfg.${deviceType}.buttonMapping}"''}
      ${lib.optionalString (cfg.${deviceType}.calibrationMatrix != null) ''Option "CalibrationMatrix" "${cfg.${deviceType}.calibrationMatrix}"''}
      ${lib.optionalString (cfg.${deviceType}.transformationMatrix != null) ''Option "TransformationMatrix" "${cfg.${deviceType}.transformationMatrix}"''}
      ${lib.optionalString (cfg.${deviceType}.clickMethod != null) ''Option "ClickMethod" "${cfg.${deviceType}.clickMethod}"''}
      Option "LeftHanded" "${xorgBool cfg.${deviceType}.leftHanded}"
      Option "MiddleEmulation" "${xorgBool cfg.${deviceType}.middleEmulation}"
      Option "NaturalScrolling" "${xorgBool cfg.${deviceType}.naturalScrolling}"
      ${lib.optionalString (cfg.${deviceType}.scrollButton != null) ''Option "ScrollButton" "${toString cfg.${deviceType}.scrollButton}"''}
      Option "ScrollMethod" "${cfg.${deviceType}.scrollMethod}"
      Option "HorizontalScrolling" "${xorgBool cfg.${deviceType}.horizontalScrolling}"
      Option "SendEventsMode" "${cfg.${deviceType}.sendEventsMode}"
      Option "Tapping" "${xorgBool cfg.${deviceType}.tapping}"
      ${lib.optionalString (cfg.${deviceType}.tappingButtonMap != null) ''Option "TappingButtonMap" "${cfg.${deviceType}.tappingButtonMap}"''}
      Option "TappingDragLock" "${xorgBool cfg.${deviceType}.tappingDragLock}"
      Option "DisableWhileTyping" "${xorgBool cfg.${deviceType}.disableWhileTyping}"
      ${cfg.${deviceType}.additionalOptions}
    '';
in {

  imports =
    (map (option: lib.mkRenamedOptionModule ([ "services" "xserver" "libinput" option ]) [ "services" "libinput" "touchpad" option ]) [
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
    ]) ++ [
      (lib.mkRenamedOptionModule [ "services" "xserver" "libinput" "enable" ]   [ "services" "libinput" "enable" ])
      (lib.mkRenamedOptionModule [ "services" "xserver" "libinput" "mouse" ]    [ "services" "libinput" "mouse" ])
      (lib.mkRenamedOptionModule [ "services" "xserver" "libinput" "touchpad" ] [ "services" "libinput" "touchpad" ])
    ];

  options = {

    services.libinput = {
      enable = lib.mkEnableOption "libinput" // {
        default = config.services.xserver.enable;
        defaultText = lib.literalExpression "config.services.xserver.enable";
      };
      mouse = mkConfigForDevice "mouse";
      touchpad = mkConfigForDevice "touchpad";
    };
  };


  config = lib.mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xorg.xf86inputlibinput ];

    environment.systemPackages = [ pkgs.xorg.xf86inputlibinput ];

    environment.etc =
      let cfgPath = "X11/xorg.conf.d/40-libinput.conf";
      in {
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
      /* {
        assertion = !config.services.xserver.synaptics.enable;
        message = "Synaptics and libinput are incompatible, you cannot enable both (in services.xserver).";
      } */
    ];

  };

}
