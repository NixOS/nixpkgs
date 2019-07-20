# Seahorse daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.seahorse = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Seahorse search provider for the GNOME Shell activity search.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.seahorse.enable {

    environment.systemPackages = [ pkgs.gnome3.seahorse pkgs.gnome3.dconf ];

    services.dbus.packages = [ pkgs.gnome3.seahorse ];

  };

}
