{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.stratis;
in
{
  options.services.stratis = {
    enable = lib.mkEnableOption "Stratis Storage - Easy to use local storage management for Linux";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.stratis-cli ];
    systemd.packages = [ pkgs.stratisd ];
    services.dbus.packages = [ pkgs.stratisd ];
    services.udev.packages = [ pkgs.stratisd ];
    systemd.services.stratisd.wantedBy = [ "sysinit.target" ];
  };
}
