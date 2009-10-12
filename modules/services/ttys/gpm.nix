{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.gpm;

in
  
{

  ###### interface

  options = {
  
    services.gpm = {
    
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable GPM, the General Purpose Mouse daemon,
          which enables mouse support in virtual consoles.
        '';
      };
        
      protocol = mkOption {
        default = "ps/2";
        description = "Mouse protocol to use.";
      };

    };
    
  };
  

  ###### implementation

  config = mkIf cfg.enable {

    jobs.gpm =
      { description = "General purpose mouse";

        startOn = "udev";
        stopOn = "shutdown";

        exec = "${pkgs.gpm}/sbin/gpm -m /dev/input/mice -t ${cfg.protocol} -D &>/dev/null";
      };

  };
  
}
