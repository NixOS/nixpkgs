{ config, pkgs, ... }:

with pkgs.lib;

let kernelVersion = config.boot.kernelPackages.kernel.version; in

{

  ###### interface

  options = {

    networking.enableB43Firmware = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want firmware for the NICs supported by the b43 module.
      '';
    };

  };


  ###### implementation

  config = mkIf config.networking.enableB43Firmware {
    assertions = singleton
      { assertion = lessThan 0 (builtins.compareVersions kernelVersion "3.2");
        message = "b43 firmware for kernels older than 3.2 not packaged yet!";
      };
    hardware.firmware = [ pkgs.b43Firmware_5_1_138 ];
  };

}
