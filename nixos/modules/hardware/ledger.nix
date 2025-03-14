{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.ledger;

in
{
  options.hardware.ledger.enable = lib.mkEnableOption "udev rules for Ledger devices";

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.ledger-udev-rules ];
  };
}
