# VirtualBox server
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.virtualbox;

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

    environment.systemPackages = [ ];
    
    jobs.virtualbox =
      { description = "VirtualBox service";
      
        startOn = "started udev";

        exec = "${pkgs.linuxPackages.virtualboxGuestAdditions}/sbin/VBoxService";
      };

  };

}
