{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hardware.framework = {
    inputmodule.enable = lib.mkEnableOption "control software for the Framework 16 input modules";
  };

  config = lib.mkIf config.hardware.framework.inputmodule.enable {
    environment.systemPackages = [ pkgs.inputmodule-control ];
    services.udev.packages = [ pkgs.inputmodule-control ];
  };
}
