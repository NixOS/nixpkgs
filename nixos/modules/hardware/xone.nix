{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.hardware.xone;
in
{
  options.hardware.xone = {
    enable = mkEnableOption "the xone driver for Xbox One and Xbox Series X|S accessories";
  };

  config = mkIf cfg.enable {
    boot = {
      blacklistedKernelModules = [
        "xpad"
        "mt76x2u"
      ];
      extraModulePackages = with config.boot.kernelPackages; [ xone ];
    };
    hardware.firmware = [ pkgs.xow_dongle-firmware ];
  };

  meta = {
    maintainers = with maintainers; [ rhysmdnz ];
  };
}
