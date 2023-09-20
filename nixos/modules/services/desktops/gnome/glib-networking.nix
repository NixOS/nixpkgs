# GLib Networking

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "glib-networking" "enable" ]
      [ "services" "gnome" "glib-networking" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.glib-networking = {

      enable = mkEnableOption (lib.mdDoc "network extensions for GLib");

    };

  };

  ###### implementation

  config = mkIf config.services.gnome.glib-networking.enable {

    services.dbus.packages = [ pkgs.glib-networking ];

    systemd.packages = [ pkgs.glib-networking ];

    environment.sessionVariables.GIO_EXTRA_MODULES = [ "${pkgs.glib-networking.out}/lib/gio/modules" ];

  };

}
