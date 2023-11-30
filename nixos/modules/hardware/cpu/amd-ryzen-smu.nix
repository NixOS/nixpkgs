{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.cpu.amd.ryzen_smu;
  ryzen_smu = config.boot.kernelPackages.ryzen_smu;
in
{
  options.hardware.cpu.amd.ryzen_smu = {
    enable = mkEnableOption (lib.mdDoc ''
        A linux kernel driver that exposes access to the SMU (System Management Unit) for certain AMD Ryzen Processors.

        WARNING: Damage cause by use of your AMD processor outside of official AMD specifications or outside of factory settings are not covered under any AMD product warranty and may not be covered by your board or system manufacturer's warranty.
      '');
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "ryzen_smu" ];
    boot.extraModulePackages = [ ryzen_smu ];
    environment.systemPackages = [ ryzen_smu ];
  };

  meta.maintainers = with maintainers; [ Cryolitia phdyellow ];

}
