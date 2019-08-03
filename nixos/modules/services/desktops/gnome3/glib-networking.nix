# GLib Networking

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.glib-networking = {

      enable = mkEnableOption "network extensions for GLib";

    };

  };

  ###### implementation

  config = mkIf config.services.gnome3.glib-networking.enable {

    services.dbus.packages = [ pkgs.gnome3.glib-networking ];

    systemd.packages = [ pkgs.gnome3.glib-networking ];

    environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gnome3.glib-networking.out}/lib/gio/modules" ];

  };

}
