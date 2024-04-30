# GNOME User Share daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.gnome-user-share = {

      enable = mkEnableOption "GNOME User Share, a user-level file sharing service for GNOME";

    };

  };


  ###### implementation

  config = mkIf config.services.gnome.gnome-user-share.enable {

    environment.systemPackages = [
      pkgs.gnome.gnome-user-share
    ];

    systemd.packages = [
      pkgs.gnome.gnome-user-share
    ];

  };

}
