# Evince.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.evince = {

      enable = mkEnableOption
        "systemd and dbus services for Evince, the GNOME document viewer";

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.evince.enable {

    environment.systemPackages = [ pkgs.evince ];

    services.dbus.packages = [ pkgs.evince ];

    systemd.packages = [ pkgs.evince ];

  };

}
