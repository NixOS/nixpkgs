{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    hardware.enableAllFirmware = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the firmware shipped in linux-firmware.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.enableAllFirmware {
    hardware.firmware = with pkgs; [
      firmwareLinuxNonfree
      intel2200BGFirmware
      rtl8723bs-firmware
    ];
  };

}
