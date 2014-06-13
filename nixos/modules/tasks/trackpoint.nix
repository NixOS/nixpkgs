{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {

    hardware.trackpoint = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable sensitivity and speed configuration for trackpoints.
        '';
      };
  
      sensitivity = mkOption {
        default = 128;
        example = 255;
        type = types.int;
        description = ''
          Configure the trackpoint sensitivity. By default, the kernel
          configures 128.
        '';
      };

      speed = mkOption {
        default = 97;
        example = 255;
        type = types.int;
        description = ''
          Configure the trackpoint sensitivity. By default, the kernel
          configures 97.
        '';
      };
      
    };

  };


  ###### implementation

  config = mkIf config.hardware.trackpoint.enable {

    jobs.trackpoint =
      { description = "Initialize trackpoint";

        startOn = "started udev";

        task = true;

        script = ''
          echo -n ${toString config.hardware.trackpoint.sensitivity} \
            > /sys/devices/platform/i8042/serio1/sensitivity
          echo -n ${toString config.hardware.trackpoint.speed} \
            > /sys/devices/platform/i8042/serio1/speed
        '';
      };
         
  };

}
