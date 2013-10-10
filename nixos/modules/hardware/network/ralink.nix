{pkgs, config, ...}:

{

  ###### interface

  options = {

    networking.enableRalinkFirmware = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the RT73 NIC.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.networking.enableRalinkFirmware {
    hardware.enableAllFirmware = true;
  };

}
