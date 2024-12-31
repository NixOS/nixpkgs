{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.colord;

in
{

  options = {

    services.colord = {
      enable = lib.mkEnableOption "colord, the color management daemon";
    };

  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.colord ];

    services.dbus.packages = [ pkgs.colord ];

    services.udev.packages = [ pkgs.colord ];

    systemd.packages = [ pkgs.colord ];

    systemd.tmpfiles.packages = [ pkgs.colord ];

    users.users.colord = {
      isSystemUser = true;
      home = "/var/lib/colord";
      group = "colord";
    };

    users.groups.colord = { };

  };

}
