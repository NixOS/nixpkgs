{ lib, config, ... }:

let
  cfg = config.hardware.hid-fanatecff;
  kernelPackages = config.boot.kernelPackages;
in
{
  options.hardware.hid-fanatecff.enable = lib.mkEnableOption "the Linux kernel drivers for Fanatec wheel bases";

  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = [ kernelPackages.hid-fanatecff ];
      kernelModules = [ "hid-fanatecf" ];
    };
    services.udev.packages = [ kernelPackages.hid-fanatecff ];
    users.groups.games = { };
  };

  meta = {
    doc = ./hid-fanatecff.md;
    maintainers = with lib.maintainers; [ theaninova ];
  };
}
