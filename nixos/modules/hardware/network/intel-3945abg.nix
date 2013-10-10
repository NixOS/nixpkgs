{ config, pkgs, ... }:

{

  ###### interface

  options = {

    networking.enableIntel3945ABGFirmware = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        This option enables automatic loading of the firmware for the Intel
        PRO/Wireless 3945ABG.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.networking.enableIntel3945ABGFirmware {

    hardware.enableAllFirmware = true;

  };

}
