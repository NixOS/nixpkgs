{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hardware.bequiet.enable = lib.mkEnableOption "support for bequiet peripherals";

  config = lib.mkIf config.hardware.bequiet.enable {
    services.udev.packages = [ pkgs.bequiet-udev-rules ];
  };

  meta = {
    maintainers = with lib.maintainers; [ niels ];
  };
}
