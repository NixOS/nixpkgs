# GNOME Documents daemon.

{ config, pkgs, lib, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
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

    environment.systemPackages = [ gnome3.gnome_terminal ];

    services.dbus.packages = [ gnome3.gnome_terminal ];

    systemd.packages = [ gnome3.gnome_terminal ];

  };

}
