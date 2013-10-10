{pkgs, config, ...}:

{

  ###### interface

  options = {

    hardware.enableAllFirmware = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want to enable all the firmware shipped with Debian/Ubuntu.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.hardware.enableAllFirmware {
    hardware.firmware = [ "${pkgs.firmwareLinuxNonfree}/lib/firmware" ];
  };

}
