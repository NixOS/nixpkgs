{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.colord;

in {

  options = {

    services.colord = {
      enable = mkEnableOption "colord, the color management daemon";
    };

  };

  config = mkIf cfg.enable {

    services.dbus.packages = [ pkgs.colord ];

    services.udev.packages = [ pkgs.colord ];

    environment.systemPackages = [ pkgs.colord ];

    systemd.services.colord = {
      description = "Manage, Install and Generate Color Profiles";
      serviceConfig = {
        Type = "dbus";
        BusName = "org.freedesktop.ColorManager";
        ExecStart = "${pkgs.colord}/libexec/colord";
        PrivateTmp = true;
      };
    };

  };

}
