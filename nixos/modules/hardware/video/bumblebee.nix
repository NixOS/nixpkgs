{ config, lib, pkgs, ... }:

with lib;
let
  kernel = config.boot.kernelPackages;
  bumblebee = if config.hardware.bumblebee.connectDisplay
              then pkgs.bumblebee_display
              else pkgs.bumblebee;

in

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
    hardware.bumblebee.connectDisplay = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Set to true if you intend to connect your discrete card to a
        monitor. This option will set up your Nvidia card for EDID
        discovery and to turn on the monitor signal.

        Only nvidia driver is supported so far.
      '';
    };
  };

  config = mkIf config.hardware.bumblebee.enable {
    boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernel.bbswitch kernel.nvidia_x11 ];

    environment.systemPackages = [ bumblebee pkgs.primus ];

    systemd.services.bumblebeed = {
      description = "Bumblebee Hybrid Graphics Switcher";
      wantedBy = [ "display-manager.service" ];
      script = "bumblebeed --use-syslog -g ${config.hardware.bumblebee.group}";
      path = [ kernel.bbswitch bumblebee ];
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
