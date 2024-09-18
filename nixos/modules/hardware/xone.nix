{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.xone;
in
{
  options.hardware.xone = {
    enable = lib.mkEnableOption "the xone driver for Xbox One and Xbox Series X|S accessories";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      blacklistedKernelModules = [ "xpad" "mt76x2u" ];
      extraModulePackages = with config.boot.kernelPackages; [ xone ];
    };
    hardware.firmware = [ pkgs.xow_dongle-firmware ];
  };

  meta = {
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
}
