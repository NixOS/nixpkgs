{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hardware.inputmodule.enable = lib.mkEnableOption ''Support for Framework input modules'';

  config = lib.mkIf config.hardware.inputmodule.enable {
    environment.systemPackages = [ pkgs.inputmodule-control ];
    services.udev.packages = [ pkgs.inputmodule-control ];
  };
}
