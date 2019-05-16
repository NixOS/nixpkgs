# File Roller.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.file-roller = {

      enable = mkEnableOption "File Roller, an archive manager for GNOME";

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.file-roller.enable {

    environment.systemPackages = [ pkgs.gnome3.file-roller ];

    services.dbus.packages = [ pkgs.gnome3.file-roller ];

  };

}
