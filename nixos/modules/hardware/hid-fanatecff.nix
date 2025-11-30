{ lib, config, ... }:

let
  cfg = config.hardware.hid-fanatecff;
  inherit (config.boot.kernelPackages) hid-fanatecff;
  inherit (lib) maintainers mkEnableOption mkIf;
in
{
  options.hardware.hid-fanatecff = {
    enable = mkEnableOption ''
      Enables Linux kernel driver that aims to add support for Fanatec devices.
    '';
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [ hid-fanatecff ];
    services.udev.packages = [ hid-fanatecff ];
  };

  meta.maintainers = with maintainers; [ rake5k ];
}
