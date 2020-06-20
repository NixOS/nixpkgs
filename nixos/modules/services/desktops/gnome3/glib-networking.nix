# GLib Networking

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome3.glib-networking = {

      enable = mkEnableOption "network extensions for GLib";

    };

  };

  ###### implementation

  config = mkIf config.services.gnome3.glib-networking.enable {

    services.dbus.packages = [ pkgs.glib-networking ];

    systemd.packages = [ pkgs.glib-networking ];

    environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.glib-networking.out}/lib/gio/modules" ];

  };

}
