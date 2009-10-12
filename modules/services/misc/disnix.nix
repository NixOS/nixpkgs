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

    jobAttrs.disnix =
      { description = "Disnix server";

        startOn = "dbus";
        stopOn = "shutdown";

        script =
          ''    
            export ACTIVATION_SCRIPTS=${pkgs.disnix_activation_scripts}/libexec/disnix/activation-scripts
            export PATH=${pkgs.nixUnstable}/bin
            export HOME=/root
	
            ${pkgs.disnix}/bin/disnix-service
          '';
      };

  };

}
