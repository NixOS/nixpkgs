{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.spice-webdavd;
in
{
  options = {
    services.spice-webdavd = {
      enable = mkEnableOption "Spice guest WebDAV daemon";
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.phodav.udev ];

    systemd.services.spice-webdavd = {
      # Config guided by https://gitlab.gnome.org/GNOME/phodav/-/blob/master/data/spice-webdavd.service
      description = "webdav daemon for Spice guests";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.phodav}/bin/spice-webdavd -p 9843";
        Restart = "on-success";
      };
    };
  };
}
