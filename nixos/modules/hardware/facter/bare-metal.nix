{ config, lib, ... }:
let
  isBaremetal = config.hardware.facter.detected.virtualisation.none.enable;
in
{
  config = lib.mkIf (config.hardware.facter.enable && isBaremetal) {
    boot.blacklistedKernelModules = lib.optionals (!config.hardware.enableRedistributableFirmware) [
      "ath3k"
    ];
  };
}
