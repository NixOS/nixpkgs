{ config, pkgs, ... }:

with pkgs.lib;

{
  ###### interface

  options = {

    powerManagement.scsiLinkPolicy = mkOption {
      default = "";
      example = "min_power";
      type = types.str;
      description = ''
        Configure the SCSI link power management policy. By default,
        the kernel configures "max_performance".
      '';
    };

  };


  ###### implementation

  config = mkIf (config.powerManagement.scsiLinkPolicy != "") {

    jobs."scsi-link-pm" =
      { description = "SCSI Link Power Management Policy";

        startOn = "stopped udevtrigger";

        task = true;

        unitConfig.ConditionPathIsReadWrite = "/sys/class/scsi_host";

        script = ''
          shopt -s nullglob
          for x in /sys/class/scsi_host/host*/link_power_management_policy; do
            echo ${config.powerManagement.scsiLinkPolicy} > $x
          done
        '';
      };

  };

}
