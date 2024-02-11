{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.colord;

in {

  options = {

    services.colord = {
      enable = mkEnableOption (lib.mdDoc "colord, the color management daemon");
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.colord ];

    services.dbus.packages = [ pkgs.colord ];

    services.udev.packages = [ pkgs.colord ];

    systemd.packages = [ pkgs.colord ];

    systemd.services.colord = {
      serviceConfig = {
        StateDirectory = "colord";
      };
    };

    systemd.tmpfiles.packages = [ pkgs.colord ];

    users.users.colord = {
      isSystemUser = true;
      group = "colord";
    };

    users.groups.colord = {};

  };

}
