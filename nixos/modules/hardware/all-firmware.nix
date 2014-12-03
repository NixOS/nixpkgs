{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    hardware.enableAllFirmware = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the firmware shipped with Debian/Ubuntu
        and iwlwifi.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.enableAllFirmware {
    hardware.firmware = [
      "${pkgs.firmwareLinuxNonfree}/lib/firmware"
      "${pkgs.iwlegacy}/lib/firmware"
      "${pkgs.iwlwifi}/lib/firmware"
    ];
  };

}
