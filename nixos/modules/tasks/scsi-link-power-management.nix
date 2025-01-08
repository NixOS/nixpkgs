{ config, lib, ... }:

let

  cfg = config.powerManagement.scsiLinkPolicy;

  kernel = config.boot.kernelPackages.kernel;

  allowedValues = [
    "min_power"
    "max_performance"
    "medium_power"
    "med_power_with_dipm"
  ];

in

{
  ###### interface

  options = {

    powerManagement.scsiLinkPolicy = lib.mkOption {
      default = null;
      type = lib.types.nullOr (lib.types.enum allowedValues);
      description = ''
        SCSI link power management policy. The kernel default is
        "max_performance".

        "med_power_with_dipm" is supported by kernel versions
        4.15 and newer.
      '';
    };

  };

  ###### implementation

  config = lib.mkIf (cfg != null) {

    assertions = lib.singleton {
      assertion = (cfg == "med_power_with_dipm") -> lib.versionAtLeast kernel.version "4.15";
      message = "med_power_with_dipm is not supported for kernels older than 4.15";
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="scsi_host", ACTION=="add", KERNEL=="host*", ATTR{link_power_management_policy}="${cfg}"
    '';
  };

}
