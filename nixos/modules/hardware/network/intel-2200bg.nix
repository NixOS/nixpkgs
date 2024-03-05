{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    networking.enableIntel2200BGFirmware = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = lib.mdDoc ''
        Turn on this option if you want firmware for the Intel
        PRO/Wireless 2200BG to be loaded automatically.  This is
        required if you want to use this device.
      '';
    };

  };


  ###### implementation

  config = lib.mkIf config.networking.enableIntel2200BGFirmware {

    hardware.firmware = [ pkgs.intel2200BGFirmware ];

  };

}
