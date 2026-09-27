{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.flux-keyboard;
  inherit (lib) mkIf mkEnableOption mkPackageOption;
in
{
  # Mounting during flashing relies on udisks2/udiskie's automounting functionality.
  options.hardware.flux-keyboard = {
    enable = mkEnableOption "support for Flux keyboard";
    package = mkPackageOption pkgs "polymath" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    environment.etc."polkit-1/rules.d/10-rpi-rp2-mount.rules".source =
      "${cfg.package}/etc/polkit-1/rules.d/10-rpi-rp2-mount.rules";
  };

  meta.maintainers = with lib.maintainers; [ BatteredBunny ];
}
