{pkgs, config, lib, ...}:

{

  ###### interface

  options = {

    networking.enableRTL8192cFirmware = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the RTL8192c (and related) NICs.
      '';
    };

  };


  ###### implementation

  config = lib.mkIf config.networking.enableRTL8192cFirmware {
    hardware.enableAllFirmware = true;
  };

}
