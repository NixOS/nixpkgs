{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.bitbox02;
in
{
  options.hardware.bitbox02 = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc "Enable udev rules for BitBox02 hardware wallet.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.bitbox ];
    users.groups.plugdev = { };
  };
}
