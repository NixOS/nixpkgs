{ config, lib, pkgs, ... }:

with lib;

{
  options = {

    hardware.sane.dsseries.enable =
      mkEnableOption (lib.mdDoc "Brother DSSeries scan backend") // {
      description = lib.mdDoc ''
        When enabled, will automatically register the "dsseries" SANE backend.

        This supports the Brother DSmobile scanner series, including the
        DS-620, DS-720D, DS-820W, and DS-920DW scanners.
      '';
    };
  };

  config = mkIf (config.hardware.sane.enable && config.hardware.sane.dsseries.enable) {

    hardware.sane.extraBackends = [ pkgs.dsseries ];
    services.udev.packages = [ pkgs.dsseries ];
    boot.kernelModules = [ "sg" ];

  };
}
