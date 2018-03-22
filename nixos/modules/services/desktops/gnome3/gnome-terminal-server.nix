# GNOME Documents daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.gnome-terminal-server = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Terminal server service,
          needed for gnome-terminal.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-terminal-server.enable {

    environment.systemPackages = [ pkgs.gnome3.gnome-terminal ];

    services.dbus.packages = [ pkgs.gnome3.gnome-terminal ];

    systemd.packages = [ pkgs.gnome3.gnome-terminal ];

  };

}
