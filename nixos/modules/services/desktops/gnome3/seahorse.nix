# Seahorse daemon.

{ config, pkgs, lib, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
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

    environment.systemPackages = [ gnome3.seahorse ];

    services.dbus.packages = [ gnome3.seahorse ];

  };

}
