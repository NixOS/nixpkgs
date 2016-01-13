{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.xserver.libinput;
in {

  options = {

    services.xserver.libinput = {

      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Whether to enable libinput support.";
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

      naturalScrolling = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enables or disables natural scrolling behavior.";
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

      scrollMethod = mkOption {
        type = types.enum [ "twofinger" "edge" "none" ];
        default = "twofinger";
        example = "edge";
        description =
          ''
            Specify the scrolling method.
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


      additionalOptions = mkOption {
        type = types.str;
        default = "";
        example = ''
          Option "RTCornerButton" "2"
          Option "RBCornerButton" "3"
        '';
        description = ''
          Additional options for libinput touchpad driver.
        '';
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
          ${optionalString (cfg.accelSpeed != null) ''Option "AccelSpeed" "${cfg.accelSpeed}"''}
          ${optionalString (cfg.buttonMapping != null) ''Option "ButtonMapping" "${cfg.buttonMapping}"''}
          ${optionalString (cfg.calibrationMatrix != null) ''Option "CalibrationMatrix" "${cfg.calibrationMatrix}"''}
          ${optionalString cfg.naturalScrolling ''Option "NaturalScrolling" "on"''}
          ${if cfg.tapping then ''Option "Tapping" "1"'' else ""}
          ${if cfg.tappingDragLock then ''Option "TappingDragLock" "1"'' else ""}
          Option "ScrollMethod" "${cfg.scrollMethod}"
          ${optionalString cfg.disableWhileTyping ''Option "DisableWhileTyping" "on"''}
          ${cfg.additionalOptions}
        EndSection
      '';

  };

}
