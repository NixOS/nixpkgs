# GNOME User Share daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  imports = [
    # Added 2021-05-07
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-user-share" "enable" ]
      [ "services" "gnome" "gnome-user-share" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.gnome-user-share = {

      enable = mkEnableOption (lib.mdDoc "GNOME User Share, a user-level file sharing service for GNOME");

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
