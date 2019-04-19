# deepin

{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    services.deepin.core.enable = lib.mkEnableOption "
      Basic dbus and systemd services, groups and users needed by the
      Deepin Desktop Environment.
    ";

  };


  ###### implementation

  config = lib.mkMerge [

    (lib.mkIf config.services.deepin.core.enable {
      environment.systemPackages = [
        pkgs.deepin.dde-api
        pkgs.deepin.dde-daemon
      ];

      services.dbus.packages = [
        pkgs.deepin.dde-api
        pkgs.deepin.dde-daemon
      ];

      systemd.packages = [
        pkgs.deepin.dde-api
        pkgs.deepin.dde-daemon
      ];

      users.groups.deepin-sound-player = { };

      users.users.deepin-sound-player = {
        description = "Deepin sound player";
        group = "deepin-sound-player";
        isSystemUser = true;
      };

      users.groups.dde-daemon = { };

      users.users.dde-daemon = {
        description = "Deepin daemon user";
        group = "dde-daemon";
        isSystemUser = true;
      };
    })

  ];

}
