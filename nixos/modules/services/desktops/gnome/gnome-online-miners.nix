# GNOME Online Miners daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-online-miners" "enable" ]
      [ "services" "gnome" "gnome-online-miners" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.gnome-online-miners = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable GNOME Online Miners, a service that
          crawls through your online content.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome.gnome-online-miners.enable {

    environment.systemPackages = [ pkgs.gnome.gnome-online-miners ];

    services.dbus.packages = [ pkgs.gnome.gnome-online-miners ];

  };

}
