{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.bumblebee;

  kernel = config.boot.kernelPackages;

  useNvidia = cfg.driver == "nvidia";

  bumblebee = pkgs.bumblebee.override {
    inherit useNvidia;
    useDisplayDevice = cfg.connectDisplay;
  };

  primus = pkgs.primus.override {
    inherit useNvidia;
  };

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
      type = types.str;
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

    hardware.bumblebee.driver = mkOption {
      default = "nvidia";
      type = types.enum [ "nvidia" "nouveau" ];
      description = ''
        Set driver used by bumblebeed. Supported are nouveau and nvidia.
      '';
    };
  };

  config = mkIf config.hardware.bumblebee.enable {
    boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];
    boot.kernelModules = [ "bbswitch" ];
    boot.extraModulePackages = [ kernel.bbswitch ] ++ optional useNvidia kernel.nvidia_x11;

    environment.systemPackages = [ bumblebee primus ];

    systemd.services.bumblebeed = {
      description = "Bumblebee Hybrid Graphics Switcher";
      wantedBy = [ "display-manager.service" ];
      path = [ kernel.bbswitch bumblebee ];
      serviceConfig = {
        ExecStart = "${bumblebee}/bin/bumblebeed --use-syslog -g ${cfg.group} --driver ${cfg.driver}";
      };
    };
  };
}
