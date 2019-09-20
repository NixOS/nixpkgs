{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    hardware.enableAllUdevRules = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the udev rules we have.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.enableAllUdevRules {
    hardware.digitalbitbox.enable = true;
    hardware.ledger.enable = true;
    hardware.logitech.enable = true;
    hardware.nitrokey.enable = true;
    hardware.onlykey.enable = true;
    hardware.usbWwan.enable = true;
  };
}
