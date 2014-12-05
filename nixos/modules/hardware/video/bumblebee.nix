{ config, lib, pkgs, ... }:

let kernel = config.boot.kernelPackages; in
with lib;

{

  options = {
    hardware.bumblebee.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable the bumblebee daemon to manage Optimus hybrid video cards.
        This should power off secondary GPU until its use is requested
        by running an application with optirun.

        Only nvidia driver is supported so far.
      '';
    };
    hardware.bumblebee.group = mkOption {
      default = "wheel";
      example = "video";
      type = types.uniq types.str;
      description = ''Group for bumblebee socket'';
    };
  };

  config = mkIf config.hardware.bumblebee.enable {
    boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernel.bbswitch kernel.nvidia_x11 ];

    environment.systemPackages = [ pkgs.bumblebee pkgs.primus ];

    systemd.services.bumblebeed = {
      description = "Bumblebee Hybrid Graphics Switcher";
      wantedBy = [ "display-manager.service" ];
      script = "bumblebeed --use-syslog -g ${config.hardware.bumblebee.group}";
      path = [ kernel.bbswitch pkgs.bumblebee ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 60;
        CPUSchedulingPolicy = "idle";
      };
      environment.LD_LIBRARY_PATH="/run/opengl-driver/lib/";
      environment.MODULE_DIR="/run/current-system/kernel-modules/lib/modules/";
    };
  };
}
