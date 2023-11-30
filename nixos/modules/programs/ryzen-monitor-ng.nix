{ pkgs, config, lib, ... }:

with lib;

let

  cfg = config.programs.ryzen_monitor_ng;

in
{

  options = {

    programs.ryzen_monitor_ng = {
      enable =  mkEnableOption (lib.mdDoc ''
        A userspace application for setting and getting Ryzen SMU (System Management Unit) parameters via the ryzen_smu kernel driver.

        Monitor power information of Ryzen processors via the PM table of the SMU.

        SMU Set and Get for many parameters and CO counts.

        https://github.com/mann1x/ryzen_monitor_ng

        WARNING: Damage cause by use of your AMD processor outside of official AMD specifications or outside of factory settings are not covered under any AMD product warranty and may not be covered by your board or system manufacturer's warranty.
      '');

      package = mkPackageOption pkgs "ryzen_monitor_ng" {};

    };

  };

  config = mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
      hardware.cpu.amd.ryzen_smu.enable = true;
  };

  meta.maintainers = with maintainers; [ Cryolitia phdyellow ];

}
