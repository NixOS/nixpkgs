{ lib, config, ... }:
let
  facterLib = import ./lib.nix lib;

  inherit (config.hardware.facter) report;
  isBaremetal = config.hardware.facter.detected.virtualisation.none.enable;
  hasAmdCpu = facterLib.hasAmdCpu report;
  hasIntelCpu = facterLib.hasIntelCpu report;
in
{
  config = lib.mkIf (config.hardware.facter.enable && isBaremetal) (
    lib.mkMerge [
      # none (e.g. bare-metal)
      # provide firmware for devices that might not have been detected by nixos-facter
      (facterLib.mkFacterAssignment {
        moduleName = "firmware";
        path = "hardware.enableRedistributableFirmware";
        value = lib.mkDefault true;
        facterValue = true;
      })

      # update microcode
      (lib.mkIf hasAmdCpu (
        facterLib.mkFacterAssignment {
          moduleName = "firmware";
          path = "hardware.cpu.amd.updateMicrocode";
          value = lib.mkDefault config.hardware.enableRedistributableFirmware;
          facterValue = true;
        }
      ))

      (lib.mkIf hasIntelCpu (
        facterLib.mkFacterAssignment {
          moduleName = "firmware";
          path = "hardware.cpu.intel.updateMicrocode";
          value = lib.mkDefault config.hardware.enableRedistributableFirmware;
          facterValue = true;
        }
      ))
    ]
  );
}
