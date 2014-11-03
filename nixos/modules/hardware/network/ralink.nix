{pkgs, config, lib, ...}:

{

  ###### interface

  options = {

    networking.enableRalinkFirmware = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the RT73 NIC.
      '';
    };

  };


  ###### implementation

  config = lib.mkIf config.networking.enableRalinkFirmware {
    hardware.enableAllFirmware = true;
  };

}
