{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {
  
    networking.wicd.enable = mkOption {
      default = false;
      description = ''
        Whether to start <command>wicd</command>. Wired and
        wireless network configurations can then be managed by
        wicd-client.
      '';
    };
  };


  ###### implementation
  
  config = mkIf config.networking.wicd.enable {

    environment.systemPackages = [pkgs.wicd];

    jobs.wicd = 
      { startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        script =
          "${pkgs.wicd}/sbin/wicd -f";
      };

    services.dbus.enable = true;
    services.dbus.packages = [pkgs.wicd];
  
  };

}
