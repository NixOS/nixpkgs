# GLib Networking

{ config, pkgs, lib, ... }:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.glib-networking = {

      enable = lib.mkEnableOption "network extensions for GLib";

    };

  };

  ###### implementation

  config = lib.mkIf config.services.gnome.glib-networking.enable {

    services.dbus.packages = [ pkgs.glib-networking ];

    systemd.packages = [ pkgs.glib-networking ];

    environment.sessionVariables.GIO_EXTRA_MODULES = [ "${pkgs.glib-networking.out}/lib/gio/modules" ];

  };

}
