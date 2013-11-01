{pkgs, config, ...}:

{

  ###### interface

  options = {

    networking.enableRTL8192cFirmware = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the RTL8192c (and related) NICs.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.networking.enableRTL8192cFirmware {
    hardware.enableAllFirmware = true;
  };

}
