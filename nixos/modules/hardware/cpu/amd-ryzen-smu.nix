{ config
, lib
, ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hardware.cpu.amd.ryzen-smu;
  ryzen-smu = config.boot.kernelPackages.ryzen-smu;
in
{
  options.hardware.cpu.amd.ryzen-smu = {
    enable = mkEnableOption ''
        ryzen_smu, a linux kernel driver that exposes access to the SMU (System Management Unit) for certain AMD Ryzen Processors.

        WARNING: Damage cause by use of your AMD processor outside of official AMD specifications or outside of factory settings are not covered under any AMD product warranty and may not be covered by your board or system manufacturer's warranty
      '';
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "ryzen-smu" ];
    boot.extraModulePackages = [ ryzen-smu ];
    environment.systemPackages = [ ryzen-smu ];
  };

  meta.maintainers = with lib.maintainers; [ Cryolitia phdyellow ];
}
