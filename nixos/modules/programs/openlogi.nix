{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.openlogi;
in
{
  options.programs.openlogi = {
    enable = lib.mkEnableOption "OpenLogi, a local-first companion for Logitech HID++ peripherals";

    package = lib.mkPackageOption pkgs "openlogi" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
  };
}
