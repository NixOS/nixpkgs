{ config, pkgs, ... }:

with pkgs.lib;

{
  ###### interface

  options = {
  
    powerManagement.scsiLinkPolicy = mkOption {
      default = "";
      example = "min_power";
      description = ''
        Configure the scsi link power management policy. By default,
        the kernel configures "max_performance".
      '';
    };
    
  };


  ###### implementation

  config = mkIf (config.powerManagement.scsiLinkPolicy != "") {

    environment.systemPackages = [ pkgs.cpufrequtils ];

    jobs.cpufreq =
      { description = "Set SCSI link power management policy";

        startOn = "started udev";

        task = true;

        script = ''
          for x in /sys/class/scsi_host/host*/link_power_management_policy; do
            echo ${config.powerManagement.scsiLinkPolicy} > $x
          done
        '';
      };
      
  };

}
