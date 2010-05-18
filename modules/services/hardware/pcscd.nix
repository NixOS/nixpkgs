{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {
  
    services.pcscd = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the PCSC-Lite daemon.";
      };
      
    };
    
  };
  

  ###### implementation

  config = mkIf config.services.pcscd.enable {

    jobs.pcscd =
      { description = "PCSC-Lite daemon";

        startOn = "started udev";

        daemonType = "fork";

        # Add to the drivers directory the only drivers we have by now: ccid
        preStart = ''
            mkdir -p /var/lib/pcsc
            rm -Rf /var/lib/pcsc/drivers
            ln -s ${pkgs.ccid}/pcsc/drivers /var/lib/pcsc/
        '';

        exec = "${pkgs.pcsclite}/sbin/pcscd";
      };
      
  };
  
}
