{ lib, config, ... }:
let
  facterLib = import ./lib.nix lib;

  inherit (config.hardware.facter) report;
  isBaremetal = config.hardware.facter.detected.virtualisation.none.enable;
  hasAmdCpu = facterLib.hasAmdCpu report;

  kver = config.boot.kernelPackages.kernel.version;
  amdPstateKernelParams =
    if (lib.versionAtLeast kver "5.17") && (lib.versionOlder kver "6.1") then
      [ "initcall_blacklist=acpi_cpufreq_init" ]
    else if (lib.versionAtLeast kver "6.1") && (lib.versionOlder kver "6.3") then
      [ "amd_pstate=passive" ]
    else if lib.versionAtLeast kver "6.3" then
      [ "amd_pstate=active" ]
    else
      [ ];
  amdPstateKernelModules = lib.optionals (
    (lib.versionAtLeast kver "5.17") && (lib.versionOlder kver "6.1")
  ) [ "amd-pstate" ];
in
lib.mkIf (config.hardware.facter.enable && isBaremetal && hasAmdCpu) {
  boot = lib.mkMerge [
    (lib.mkIf ((lib.versionAtLeast kver "5.17") && (lib.versionOlder kver "6.1")) {
      kernelParams = amdPstateKernelParams;
      kernelModules = amdPstateKernelModules;
    })
    (lib.mkIf ((lib.versionAtLeast kver "6.1") && (lib.versionOlder kver "6.3")) {
      kernelParams = amdPstateKernelParams;
    })
    (lib.mkIf (lib.versionAtLeast kver "6.3") {
      kernelParams = amdPstateKernelParams;
    })
  ];

  hardware.facter.changes = {
    "boot.kernelParams"."amd-cpu" = amdPstateKernelParams;
  }
  // lib.optionalAttrs (amdPstateKernelModules != [ ]) {
    "boot.kernelModules"."amd-cpu" = amdPstateKernelModules;
  };
}
