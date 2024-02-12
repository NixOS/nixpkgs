{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.spice-webdavd;
in
{
  options = {
    services.spice-webdavd = {
      enable = mkEnableOption (lib.mdDoc "the spice guest webdav proxy daemon");

      package = mkPackageOption pkgs "phodav" { };
    };
  };

  config = mkIf cfg.enable {
    # ensure the webdav fs this exposes can actually be mounted
    services.davfs2.enable = true;

    # add the udev rule which starts the proxy when the spice socket is present
    services.udev.packages = [ cfg.package ];

    systemd.services.spice-webdavd = {
      description = "spice-webdav proxy daemon";

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/spice-webdavd -p 9843";
        Restart = "on-success";
      };
    };
  };
}
