{ config, pkgs, ... }:

let kernel = config.boot.kernelPackages; in
with pkgs.lib;

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
  };

  config = mkIf config.hardware.bumblebee.enable {
    boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernel.bbswitch kernel.nvidia_x11 ];

    environment.systemPackages = [ pkgs.bumblebee ];

    systemd.services.bumblebeed = {
      description = "Bumblebee Hybrid Graphics Switcher";
      wantedBy = [ "display-manager.service" ];
      script = "bumblebeed --use-syslog";
      path = [ kernel.bbswitch pkgs.bumblebee ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 60;
        CPUSchedulingPolicy = "idle";
      };
    };
  };
}
