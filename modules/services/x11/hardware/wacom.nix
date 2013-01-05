{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xserver.wacom;

in

{

  options = {

    services.xserver.wacom = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the Wacom touchscreen/digitizer/tablet.";
      };

      device = mkOption {
        default = null;
        example = "/dev/ttyS0";
        description = "Device to use. Set to null for autodetect (think USB tablet).";
      };

      forceDeviceType = mkOption {
        default = null;
        example = "ISDV4";
        description = "Some models (think touchscreen) require the device type to be specified. Set to null for autodetect (think USB tablet).";
      };

      stylusExtraConfig = mkOption {
        default = "";
        example = ''
            Option "Button1" "2"
          '';
        description = "Lines to be added to Wacom_stylus InputDevice section.";
      };

      eraserExtraConfig = mkOption {
        default = "";
        example = ''
            Option "Button2" "3"
          '';
        description = "Lines to be added to Wacom_eraser InputDevice section.";
      };

      cursorExtraConfig = mkOption {
        default = "";
        example = "";
        description = "Lines to be added to Wacom_cursor InputDevice section.";
      };

    };

  };


  config = mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xf86_input_wacom ];

    services.udev.packages = [ pkgs.xf86_input_wacom ];

    services.xserver.serverLayoutSection =
      ''
        InputDevice "Wacom_stylus"
        InputDevice "Wacom_eraser"
        InputDevice "Wacom_cursor"
      '';

    services.xserver.config =
      ''
        Section "InputDevice"
          Driver "wacom"
          Identifier "Wacom_stylus"
          ${optionalString (cfg.device != null) ''
            Option "Device" "${cfg.device}"
          ''}
          Option "Type" "stylus"
          ${optionalString (cfg.forceDeviceType != null) ''
            Option "ForceDevice" "${cfg.forceDeviceType}"
          ''}
          ${cfg.stylusExtraConfig}
        EndSection

        Section "InputDevice"
          Driver "wacom"
          Identifier "Wacom_eraser"
          ${optionalString (cfg.device != null) ''
            Option "Device" "${cfg.device}"
          ''}
          Option "Type" "eraser"
          ${optionalString (cfg.forceDeviceType != null) ''
            Option "ForceDevice" "${cfg.forceDeviceType}"
          ''}
          ${cfg.eraserExtraConfig}
        EndSection

        Section "InputDevice"
          Driver "wacom"
          Identifier "Wacom_cursor"
          ${optionalString (cfg.device != null) ''
            Option "Device" "${cfg.device}"
          ''}
          Option "Type" "cursor"
          ${optionalString (cfg.forceDeviceType != null) ''
            Option "ForceDevice" "${cfg.forceDeviceType}"
          ''}
          ${cfg.cursorExtraConfig}
        EndSection
      '';

  };

}
