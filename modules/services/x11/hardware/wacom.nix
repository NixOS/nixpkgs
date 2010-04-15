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
        description = "Whether to enable the Wacom touchscreen/digitizer.";
      };

      device = mkOption {
        default = "/dev/ttyS0";
        description = "Device to use.";
      };

      forceDeviceType = mkOption {
        default = "ISDV4";
        example = null;
        description = "Some models (think touchscreen) require the device type to be specified.";
      };

    };

  };


  config = mkIf cfg.enable {

    services.xserver.modules = [ pkgs.xf86_input_wacom ];

    services.udev.packages = [ pkgs.xf86_input_wacom ];

    services.xserver.serverLayoutSection =
      ''
        InputDevice "Wacom_stylus"
        InputDevice "Wacom_cursor"
        InputDevice "Wacom_eraser"
      '';

    services.xserver.config =
      ''
        Section "InputDevice"
          Driver "wacom"
          Identifier "Wacom_stylus"
          Option "Device" "${cfg.device}"
          Option "Type" "stylus"
          ${optionalString (cfg.forceDeviceType != null) ''
            Option "ForceDevice" "${cfg.forceDeviceType}"
          ''}
          Option "Button2" "3"
        EndSection

        Section "InputDevice"
          Driver "wacom"
          Identifier "Wacom_eraser"
          Option "Device" "${cfg.device}"
          Option "Type" "eraser"
          ${optionalString (cfg.forceDeviceType != null) ''
            Option "ForceDevice" "${cfg.forceDeviceType}"
          ''}
          Option "Button1" "2"
        EndSection

        Section "InputDevice"
          Driver "wacom"
          Identifier "Wacom_cursor"
          Option "Device" "${cfg.device}"
          Option "Type" "cursor"
          ${optionalString (cfg.forceDeviceType != null) ''
            Option "ForceDevice" "${cfg.forceDeviceType}"
          ''}
        EndSection
      '';

  };

}
