# GNOME User Share daemon.

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

    services.gnome.gnome-user-share = {

      enable = lib.mkEnableOption "GNOME User Share, a user-level file sharing service for GNOME";

    };

  };

  ###### implementation

  config = lib.mkIf config.services.gnome.gnome-user-share.enable {

    environment.systemPackages = [
      pkgs.gnome.gnome-user-share
    ];

    systemd.packages = [
      pkgs.gnome.gnome-user-share
    ];

  };

}
