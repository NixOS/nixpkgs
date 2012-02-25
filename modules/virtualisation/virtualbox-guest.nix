# Module for VirtualBox guests.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.virtualbox;
  kernel = config.boot.kernelPackages;

in

{

  ###### interface

  options = {

    services.virtualbox = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the VirtualBox service and other guest additions.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ kernel.virtualboxGuestAdditions ];

    boot.extraModulePackages = [ kernel.virtualboxGuestAdditions ];

    jobs.virtualbox =
      { description = "VirtualBox service";

        startOn = "started udev";

        exec = "${kernel.virtualboxGuestAdditions}/sbin/VBoxService --foreground";
      };

  };

}
