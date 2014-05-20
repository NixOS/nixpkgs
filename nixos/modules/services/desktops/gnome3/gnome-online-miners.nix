# GNOME Online Miners daemon.

{ config, pkgs, ... }:

with pkgs.lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

  ###### interface

  options = {

    services.gnome3.gnome-online-miners = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Online Miners, a service that
          crawls through your online content.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-online-miners.enable {

    environment.systemPackages = [ gnome3.gnome-online-miners ];

    services.dbus.packages = [ gnome3.gnome-online-miners ];

  };

}
