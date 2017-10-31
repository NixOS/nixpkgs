{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.thermald;
in {
  ###### interface
  options = { 
    services.thermald = { 
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable thermald, the temperature management daemon.
        ''; 
      };  
    };  
  };  

  ###### implementation
  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.thermald ];

    systemd.services.thermald = {
      description = "Thermal Daemon Service";
      wantedBy = [ "multi-user.target" ];
      script = "exec ${pkgs.thermald}/sbin/thermald --no-daemon --dbus-enable";
    };
  };
}
