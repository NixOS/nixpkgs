# GNOME Disks.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  options = {

    programs.gnome-disks = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Disks daemon, a program designed to
          be a UDisks2 graphical front-end.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.programs.gnome-disks.enable {

    environment.systemPackages = [ pkgs.gnome.gnome-disk-utility ];

    services.dbus.packages = [ pkgs.gnome.gnome-disk-utility ];

  };

}
