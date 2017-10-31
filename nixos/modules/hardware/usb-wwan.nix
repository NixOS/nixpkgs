{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {

    hardware.usbWwan = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable this option to support USB WWAN adapters.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf config.hardware.usbWwan.enable {
    services.udev.packages = with pkgs; [ usb-modeswitch-data ];
  };
}
