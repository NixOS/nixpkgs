# GNOME Online Accounts daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome3.gnome-online-accounts = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Online Accounts daemon, a service that provides
          a single sign-on framework for the GNOME desktop.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-online-accounts.enable {

    environment.systemPackages = [ pkgs.gnome-online-accounts ];

    services.dbus.packages = [ pkgs.gnome-online-accounts ];

  };

}
