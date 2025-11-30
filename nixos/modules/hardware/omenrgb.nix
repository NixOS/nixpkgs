{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.hardware.omenrgb;
in
{
  options.hardware.omenrgb = {
    enable = mkEnableOption "Keyboard backlight rgb controller for HP Omen Laptops";
    package = mkPackageOption pkgs "omenrgb" { };
  };

  config = mkIf cfg.enable {
    boot = {
      extraModulePackages = with config.boot.kernelPackages; [ hp-omen-wmi ];
      kernelModules = [ "hp-wmi" ];
    };

    services.udev.packages = [ cfg.package ];

    environment.systemPackages = [ cfg.package ];

  };

  meta.maintainers = pkgs.omenrgb.meta.maintainers;
}
