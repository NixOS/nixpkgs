{
  config,
  lib,
  ...
}:

let
  cfg = config.hardware.xpad-noone;
in
{
  options.hardware.xpad-noone = {
    enable = lib.mkEnableOption "The Xpad driver from the Linux kernel with support for Xbox One controllers removed";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      blacklistedKernelModules = [ "xpad" ];
      extraModulePackages = with config.boot.kernelPackages; [ xpad-noone ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ Cryolitia ];
  };
}
