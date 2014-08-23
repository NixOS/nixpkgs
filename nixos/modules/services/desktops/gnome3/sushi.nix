# GNOME Sushi daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

  ###### interface

  options = {

    services.gnome3.sushi = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Sushi, a quick previewer for nautilus.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.sushi.enable {

    environment.systemPackages = [ gnome3.sushi ];

    services.dbus.packages = [ gnome3.sushi ];

  };

}
