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
          for directory in /sys/devices/platform/i8042/serio1 \
                           /sys/devices/platform/i8042/serio1/serio2 \
                           /sys/devices/platform/i8042/serio4/serio5; do
            if [ -e "$directory/speed" ]; then
              echo -n ${toString config.hardware.trackpoint.speed} \
                > "$directory/speed"
              echo -n ${toString config.hardware.trackpoint.sensitivity} \
                > "$directory/sensitivity"
              break
            fi
          done
        '';
      };
         
  };

}
