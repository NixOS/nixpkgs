{pkgs, config, ...}:

{

  ###### interface

  options = {

    hardware.enableFirmwareLinuxFree = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want the set of firmware of the linux-firmware-free package.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.hardware.enableFirmwareLinuxFree {
    hardware.firmware = [ pkgs.firmwareLinuxFree ];
  };

}
