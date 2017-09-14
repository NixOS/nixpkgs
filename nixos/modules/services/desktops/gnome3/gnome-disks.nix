# GNOME Disks daemon.

{ config, pkgs, lib, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

  ###### interface

  options = {

    services.gnome3.gnome-disks = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Disks daemon, a service designed to
          be a UDisks2 graphical front-end.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-disks.enable {

    environment.systemPackages = [ gnome3.gnome-disk-utility ];

    services.dbus.packages = [ gnome3.gnome-disk-utility ];

  };

}
