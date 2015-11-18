{ config, lib, pkgs, ... }:

with lib;

let cfg = config.powerManagement.scsiLinkPolicy; in

{
  ###### interface

  options = {

    powerManagement.scsiLinkPolicy = mkOption {
      default = null;
      type = types.nullOr (types.enum [ "min_power" "max_performance" "medium_power" ]);
      description = ''
        SCSI link power management policy. The kernel default is
        "max_performance".
      '';
    };

  };


  ###### implementation

  config = mkIf (cfg != null) {
    services.udev.extraRules = ''
      SUBSYSTEM=="scsi_host", ACTION=="add", KERNEL=="host*", ATTR{link_power_management_policy}="${cfg}"
    '';
  };

}
