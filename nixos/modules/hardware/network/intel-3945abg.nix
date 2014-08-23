{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    networking.enableIntel3945ABGFirmware = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        This option enables automatic loading of the firmware for the Intel
        PRO/Wireless 3945ABG.
      '';
    };

  };


  ###### implementation

  config = lib.mkIf config.networking.enableIntel3945ABGFirmware {

    hardware.enableAllFirmware = true;

  };

}
