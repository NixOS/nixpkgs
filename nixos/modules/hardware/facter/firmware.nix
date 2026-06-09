{ lib, config, ... }:
let
  facterLib = import ./lib.nix lib;

  inherit (config.hardware.facter) report;
  isBaremetal = config.hardware.facter.detected.virtualisation.none.enable;
  hasAmdCpu = facterLib.hasAmdCpu report;
  hasIntelCpu = facterLib.hasIntelCpu report;
in
{
  config = lib.mkIf (config.hardware.facter.enable && isBaremetal) {
    # none (e.g. bare-metal)
    # provide firmware for devices that might not have been detected by nixos-facter
    hardware.enableRedistributableFirmware = lib.mkDefault true;

    # update microcode
    hardware.cpu.amd.updateMicrocode = lib.mkIf hasAmdCpu (
      lib.mkDefault config.hardware.enableRedistributableFirmware
    );
    hardware.cpu.intel.updateMicrocode = lib.mkIf hasIntelCpu (
      lib.mkDefault config.hardware.enableRedistributableFirmware
    );

    hardware.facter.changes = {
      "hardware.enableRedistributableFirmware".firmware = true;
    }
    // lib.optionalAttrs hasAmdCpu {
      "hardware.cpu.amd.updateMicrocode".firmware = true;
    }
    // lib.optionalAttrs hasIntelCpu {
      "hardware.cpu.intel.updateMicrocode".firmware = true;
    };
  };
}
