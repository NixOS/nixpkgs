# Udisks daemon.

{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface
  
  options = {
  
    services.udisks = {
    
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable support for Udisks, a DBus service that
          allows applications to query and manipulate storage devices.
        '';
      };

    };
    
  };


  ###### implementation
  
  config = mkIf config.services.udisks.enable {

    environment.systemPackages = [ pkgs.udisks ];

    services.dbus.packages = [ pkgs.udisks ];

  };

}
