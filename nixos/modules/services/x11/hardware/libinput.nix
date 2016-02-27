{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.libinput;
    xorgBool = v: if v then "on" else "off";
in {

  options = {

    services.xserver.libinput = {

      enable = mkEnableOption "libinput";

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

      accelProfile = mkOption {
        type = types.enum [ "flat" "adaptive" ];
        default = "flat";
        example = "adaptive";
        description =
          ''
            Sets  the pointer acceleration profile to the given profile. Permitted values are adaptive, flat.
            Not all devices support this option or all profiles. If a profile is unsupported, the default profile
            for this is used. For a description on the profiles and their behavior, see the libinput documentation.
          '';
      };    
      
      accelSpeed = mkOption {
        type = types.nullOr types.string;
        default = null;
        description = "Cursor acceleration (how fast speed increases from minSpeed to maxSpeed).";
      };

      buttonMapping = mkOption {
        type = types.nullOr types.string;
        default = null;
        description =
          ''
            Sets the logical button mapping for this device, see XSetPointerMapping(3). The string  must
            be  a  space-separated  list  of  button mappings in the order of the logical buttons on the
            device, starting with button 1.  The default mapping is "1 2 3 ... 32". A mapping of 0 deac‐
            tivates the button. Multiple buttons can have the same mapping.  Invalid mapping strings are
            discarded and the default mapping is used for all buttons.  Buttons  not  specified  in  the
            user's mapping use the default mapping. See section BUTTON MAPPING for more details.
          '';
      };

      calibrationMatrix = mkOption {
        type = types.nullOr types.string;
        default = null;
        description =
          ''
            A  string  of  9 space-separated floating point numbers.  Sets the calibration matrix to the
            3x3 matrix where the first row is (abc), the second row is (def) and the third row is (ghi).
          '';
      };

      clickMethod = mkOption {
        type = types.nullOr (types.enum [ "none" "buttonareas" "clickfinger" ]);
        default = null;
        example = "none";
        description =
          ''
            Enables a click method. Permitted values are none, buttonareas, clickfinger.
            Not all devices support all methods, if an option is unsupported,
            the default click method for this device is used. 
          '';
      };
      
      leftHanded = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enables left-handed button orientation, i.e. swapping left and right buttons.";
      };

      middleEmulation = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description =
          ''
            Enables middle button emulation. When enabled, pressing the left and right buttons
            simultaneously produces a middle mouse button click.
          '';
      };
      
      naturalScrolling = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enables or disables natural scrolling behavior.";
      };

      scrollButton = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 1;
        description =
          ''
            Designates a button as scroll button. If the ScrollMethod is button and the button is logically
            held down, x/y axis movement is converted into scroll events.
          '';
      };

      scrollMethod = mkOption {
        type = types.enum [ "twofinger" "edge" "none" ];
        default = "twofinger";
        example = "edge";
        description =
          ''
            Specify the scrolling method.
          '';
      };

      horizontalScrolling = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description =
          ''
            Disables horizontal scrolling. When disabled, this driver will discard any horizontal scroll
            events from libinput. Note that this does not disable horizontal scrolling, it merely
            discards the horizontal axis from any scroll events.
          '';
      };

      sendEventsMode = mkOption {
        type = types.enum [ "disabled" "enabled" "disabled-on-external-mouse" ];
        default = "enabled";
        example = "disabled";
        description =
          ''
            Sets the send events mode to disabled, enabled, or "disable when an external mouse is connected".
          '';
      };

      tapping = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description =
          ''
            Enables or disables tap-to-click behavior.
          '';
      };

      tappingDragLock = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description =
          ''
            Enables or disables drag lock during tapping behavior. When enabled, a finger up during tap-
            and-drag will not immediately release the button. If the finger is set down again within the
            timeout, the draging process continues.
          '';
      };

      disableWhileTyping = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description =
          ''
            Disable input method while typing.
          '';
      };

      additionalOptions = mkOption {
        type = types.str;
        default = "";
        example =
        ''
          Option "DragLockButtons" "L1 B1 L2 B2"
        '';
        description = "Additional options for libinput touchpad driver.";
      };

    };

  };


  config = mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xorg.xf86inputlibinput ];

    environment.systemPackages = [ pkgs.xorg.xf86inputlibinput ];

    services.xserver.config =
      ''
        # Automatically enable the libinput driver for all touchpads.
        Section "InputClass"
          Identifier "libinputConfiguration"
          MatchIsTouchpad "on"
          ${optionalString (cfg.dev != null) ''MatchDevicePath "${cfg.dev}"''}
          Driver "libinput"
          Option "AccelProfile" "${cfg.accelProfile}"
          ${optionalString (cfg.accelSpeed != null) ''Option "AccelSpeed" "${cfg.accelSpeed}"''}
          ${optionalString (cfg.buttonMapping != null) ''Option "ButtonMapping" "${cfg.buttonMapping}"''}
          ${optionalString (cfg.calibrationMatrix != null) ''Option "CalibrationMatrix" "${cfg.calibrationMatrix}"''}
          ${optionalString (cfg.clickMethod != null) ''Option "ClickMethod" "${cfg.clickMethod}"''}
          Option "LeftHanded" "${xorgBool cfg.leftHanded}"
          Option "MiddleEmulation" "${xorgBool cfg.middleEmulation}"
          Option "NaturalScrolling" "${xorgBool cfg.naturalScrolling}"
          ${optionalString (cfg.scrollButton != null) ''Option "ScrollButton" "${cfg.scrollButton}"''}
          Option "ScrollMethod" "${cfg.scrollMethod}"
          Option "HorizontalScrolling" "${xorgBool cfg.horizontalScrolling}"
          Option "SendEventsMode" "${cfg.sendEventsMode}"
          Option "Tapping" "${xorgBool cfg.tapping}"
          Option "TappingDragLock" "${xorgBool cfg.tappingDragLock}"
          Option "DisableWhileTyping" "${xorgBool cfg.disableWhileTyping}"
          ${cfg.additionalOptions}
        EndSection
      '';

  };

}
