{pkgs, config, ...}:

{

  ###### interface

  options = {

    hardware.enableFirmwareLinuxNonfree = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want the set of firmware of the non-free package.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.hardware.enableFirmwareLinuxNonfree {
    hardware.firmware = [ pkgs.firmwareLinuxNonfree ];
  };

}
