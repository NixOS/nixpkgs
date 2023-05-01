{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.deepin.members;
  };

  ###### interface

  options = {

    services.deepin.dde-api = {

      enable = mkEnableOption (lib.mdDoc ''
        Provides some dbus interfaces that is used for screen zone detecting,
        thumbnail generating, and sound playing in Deepin Desktop Enviroment.
      '');

    };

  };


  ###### implementation

  config = mkIf config.services.deepin.dde-api.enable {

     environment.systemPackages = [ pkgs.deepin.dde-api ];

     services.dbus.packages = [ pkgs.deepin.dde-api ];

     systemd.packages = [ pkgs.deepin.dde-api ];

     environment.pathsToLink = [ "/lib/deepin-api" ];

     users.groups.deepin-sound-player = { };
     users.users.deepin-sound-player = {
       description = "Deepin sound player";
       home = "/var/lib/deepin-sound-player";
       createHome = true;
       group = "deepin-sound-player";
       isSystemUser = true;
     };

  };

}
