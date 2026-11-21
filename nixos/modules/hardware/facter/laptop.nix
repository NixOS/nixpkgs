{ config, lib, ... }:
let
  inherit (config.hardware.facter) report;
in
{
  config =
    lib.mkIf (config.hardware.facter.enable && report.hardware.system.form_factor == "laptop")
      {
        services.tlp.enable = lib.mkDefault (!config.services.power-profiles-daemon.enable);
      };
}
