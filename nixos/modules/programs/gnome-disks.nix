# GNOME Disks.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2019-08-09
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-disks" "enable" ]
      [ "programs" "gnome-disks" "enable" ])
  ];

  ###### interface

  options = {

    programs.gnome-disks = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
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
