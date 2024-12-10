# GNOME Sushi daemon.

{
  config,
  lib,
  pkgs,
  ...
}:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.sushi = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable Sushi, a quick previewer for nautilus.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.gnome.sushi.enable {

    environment.systemPackages = [ pkgs.gnome.sushi ];

    services.dbus.packages = [ pkgs.gnome.sushi ];

  };

}
