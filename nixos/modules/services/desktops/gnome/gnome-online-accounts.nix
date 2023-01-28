# GNOME Online Accounts daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-online-accounts" "enable" ]
      [ "services" "gnome" "gnome-online-accounts" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.gnome-online-accounts = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable GNOME Online Accounts daemon, a service that provides
          a single sign-on framework for the GNOME desktop.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome.gnome-online-accounts.enable {

    environment.systemPackages = [ pkgs.gnome-online-accounts ];

    services.dbus.packages = [ pkgs.gnome-online-accounts ];

  };

}
