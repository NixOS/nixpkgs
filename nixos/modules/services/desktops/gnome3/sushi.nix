# GNOME Sushi daemon.

{ config, lib, pkgs, ... }:

with lib;

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

    environment.systemPackages = [ pkgs.gnome3.sushi ];

    services.dbus.packages = [ pkgs.gnome3.sushi ];

  };

}
