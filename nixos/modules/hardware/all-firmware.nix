{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    hardware.enableAllFirmware = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the firmware shipped with Debian/Ubuntu.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.enableAllFirmware {
    hardware.firmware = [ "${pkgs.firmwareLinuxNonfree}/lib/firmware" ];
  };

}
