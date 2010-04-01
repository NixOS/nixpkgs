# Disnix server
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.disnix;

in

{

  ###### interface
  
  options = {
  
    services.disnix = {
    
      enable = mkOption {
        default = false;
        description = "Whether to enable Disnix";
      };        

    };
    
  };
  

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.disnix ];

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.disnix ];

    jobs.disnix =
      { description = "Disnix server";

        startOn = "started dbus";

        script =
          ''                
            export PATH=/var/run/current-system/sw/bin:/var/run/current-system/sw/sbin
            export HOME=/root
	
            ${pkgs.disnix}/bin/disnix-service --activation-modules-dir=${pkgs.disnix_activation_scripts}/libexec/disnix/activation-scripts
          '';
      };

  };

}
