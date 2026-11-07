{ config, lib, ... }:

let
  cfg = config.hardware.simagic;
  inherit (config.boot.kernelPackages) simagic-ff;
in
{
  options.hardware.simagic.enable = lib.mkEnableOption "Simagic force feedback and local device access";

  meta.maintainers = [ lib.maintainers.jeremyrempel ];

  config = lib.mkIf cfg.enable {
    boot.extraModulePackages = [ simagic-ff ];
    boot.kernelModules = [ "hid-simagic-ff" ];
    services.udev.packages = [ simagic-ff ];
  };
}
