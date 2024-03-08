# GNOME Sushi daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  imports = [
    # Added 2021-05-07
    (mkRenamedOptionModule
      [ "services" "gnome3" "sushi" "enable" ]
      [ "services" "gnome" "sushi" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.sushi = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable Sushi, a quick previewer for nautilus.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome.sushi.enable {

    environment.systemPackages = [ pkgs.gnome.sushi ];

    services.dbus.packages = [ pkgs.gnome.sushi ];

  };

}
