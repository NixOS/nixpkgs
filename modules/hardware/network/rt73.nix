{pkgs, config, ...}:

{

  ###### interface

  options = {
  
    networking.enableRT73Firmware = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the RT73 NIC
      '';
    };

  };


  ###### implementation
  
  config = pkgs.lib.mkIf config.networking.enableRT73Firmware {
    hardware.firmware = [ pkgs.rt73fw ];
  };
  
}
