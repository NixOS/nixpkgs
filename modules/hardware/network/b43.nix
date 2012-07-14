{pkgs, config, ...}:

let kernelVersion = config.boot.kernelPackages.kernel.version; in

{

  ###### interface

  options = {

    networking.enableB43Firmware = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = ''
        Turn on this option if you want firmware for the NICs supported by the b43 module.
      '';
    };

  };


  ###### implementation

  config = pkgs.lib.mkIf config.networking.enableB43Firmware {
    hardware.firmware = if builtins.lessThan (builtins.compareVersions kernelVersion "3.2") 0 then
      throw "b43 firmware for kernels older than 3.2 not packaged yet!" else
      [ pkgs.b43Firmware_5_1_138 ];
  };

}
