# GNOME Disks.

{
  config,
  pkgs,
  lib,
  ...
}:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    programs.gnome-disks = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Disks daemon, a program designed to
          be a UDisks2 graphical front-end.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.programs.gnome-disks.enable {

    environment.systemPackages = [ pkgs.gnome-disk-utility ];

    services.dbus.packages = [ pkgs.gnome-disk-utility ];

  };

}
