{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    networking.enableIntel2100BGFirmware = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the Intel
        PRO/Wireless 2100BG to be loaded automatically.  This is
        required if you want to use this device.
      '';
    };

  };


  ###### implementation

  config = lib.mkIf config.networking.enableIntel2100BGFirmware {

    hardware.enableAllFirmware = true;

  };

}
