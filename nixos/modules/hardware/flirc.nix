{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.flirc;
in
{
  options.hardware.flirc.enable = lib.mkEnableOption "software to configure a Flirc USB device";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.flirc ];
    services.udev.packages = [ pkgs.flirc ];
  };
}
