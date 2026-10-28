{ lib, config, ... }:
let
  facterLib = import ./lib.nix lib;

  inherit (config.hardware.facter) report;
  isBaremetal = config.hardware.facter.detected.virtualisation.none.enable;
  hasAmdCpu = facterLib.hasAmdCpu report;

  kver = config.boot.kernelPackages.kernel.version;
in
lib.mkIf (config.hardware.facter.enable && isBaremetal && hasAmdCpu) {
  boot = lib.mkMerge [
    (lib.mkIf ((lib.versionAtLeast kver "5.17") && (lib.versionOlder kver "6.1")) {
      kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
      kernelModules = [ "amd-pstate" ];
    })
    (lib.mkIf ((lib.versionAtLeast kver "6.1") && (lib.versionOlder kver "6.3")) {
      kernelParams = [ "amd_pstate=passive" ];
    })
    (lib.mkIf (lib.versionAtLeast kver "6.3") {
      kernelParams = [ "amd_pstate=active" ];
    })
  ];
}
