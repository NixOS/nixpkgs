# GNOME Online Accounts daemon.

{ config, pkgs, ... }:

with pkgs.lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

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

    environment.systemPackages = [ gnome3.gnome_online_accounts ];

    services.dbus.packages = [ gnome3.gnome_online_accounts ];

  };

}
