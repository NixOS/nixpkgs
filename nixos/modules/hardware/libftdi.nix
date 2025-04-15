{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.libftdi;
in
{
  options.hardware.libftdi = {
    enable = lib.mkEnableOption "udev rules for devices supported by libftdi";
    package = lib.mkPackageOption pkgs "libftdi1" { };
  };

  config = lib.mkIf cfg.enable {
    users.groups.ftdi = { };
    services.udev.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ felixsinger ];
}
