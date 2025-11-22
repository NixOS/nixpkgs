{ lib, config, ... }:
let
  facterLib = import ./lib.nix lib;

  inherit (config.hardware.facter) report;
in
{
  options.hardware.facter.detected.boot.disk.kernelModules = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = lib.uniqueStrings (
      facterLib.collectDrivers (
        # A disk might be attached.
        (report.hardware.firewire_controller or [ ])
        # definitely important
        ++ (report.hardware.disk or [ ])
        ++ (report.hardware.storage_controller or [ ])
      )
    );
    defaultText = "hardware dependent";
    description = ''
      List of kernel modules that are needed to access the disk.
    '';
  };

  config = lib.mkIf (config.hardware.facter.reportPath != null) {
    boot.initrd.availableKernelModules = config.hardware.facter.detected.boot.disk.kernelModules;
  };
}
