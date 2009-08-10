# This module provides support for automatic loading of firmware from
# kernel modules. 
{pkgs, config, ...}:

with pkgs.lib;

let

  firmwareLoader = pkgs.substituteAll {
    src = ./udev-firmware-loader.sh;
    path = "${pkgs.coreutils}/bin";
    isExecutable = true;
    firmwareDirs = config.hardware.firmware;
  };

in

{

  ###### interface
  
  options = {

    hardware.firmware = mkOption {
      default = [];
      example = ["/root/my-firmware"];
      merge = mergeListOption; 
      description = ''
        List of directories containing firmware files.  Such files
        will be loaded automatically if the kernel asks for them
        (i.e., when it has detected specific hardware that requires
        firmware to function).
      '';
    };

  };


  ###### implementation
  
  config = {

    services.udev.extraRules =
      ''
        # Firmware loading.
        SUBSYSTEM=="firmware", ACTION=="add", RUN+="${firmwareLoader}"
      '';

  };
  
}
