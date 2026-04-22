{ lib, config, ... }:
let
  inherit (lib) types;
  cfg = config.hardware.cpu.amd.pstate;
  kver = config.boot.kernelPackages.kernel.version;

  kernel6_1To6_3 = (lib.versionAtLeast kver "6.1") && (lib.versionOlder kver "6.3");
  kernel6_3OrLater = lib.versionAtLeast kver "6.3";
in
{
  options.hardware.cpu.amd.pstate = {
    enable = lib.mkEnableOption "AMD CPU performance control";

    mode = lib.mkOption {
      type = types.nullOr (
        types.enum [
          "active"
          "passive"
          "guided"
        ]
      );
      default =
        if kernel6_3OrLater then
          "active"
        else if kernel6_1To6_3 then
          "passive"
        else
          null;

      defaultText = "Dependent on the Linux kernel version";
      description = ''
        The different performance characteristics of `amd_pstate` modes are described here: https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html#amd-pstate-driver-operation-modes
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot = lib.mkMerge [
      (lib.mkIf (cfg.mode == null) {
        kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
        kernelModules = [ "amd-pstate" ];
      })
      (lib.mkIf (cfg.mode != null) {
        kernelParams = [ "amd_pstate=${cfg.mode}" ];
      })
    ];
  };
}
