# deepin

{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    services.deepin.core.enable = lib.mkEnableOption "
      Basic dbus and systemd services, groups and users needed by the
      Deepin Desktop Environment.
    ";

    services.deepin.deepin-menu.enable = lib.mkEnableOption "
      DBus service for unified menus in Deepin Desktop Environment.
    ";

    services.deepin.deepin-turbo.enable = lib.mkEnableOption "
      Turbo service for the Deepin Desktop Environment. It is a daemon
      that helps to launch applications faster.
    ";

  };


  ###### implementation

  config = lib.mkMerge [

    (lib.mkIf config.services.deepin.core.enable {
      environment.systemPackages = [
        pkgs.deepin.dde-api
        pkgs.deepin.dde-calendar
        pkgs.deepin.dde-daemon
        pkgs.deepin.dde-session-ui
        pkgs.deepin.deepin-image-viewer
      ];

      services.dbus.packages = [
        pkgs.deepin.dde-api
        pkgs.deepin.dde-calendar
        pkgs.deepin.dde-daemon
        pkgs.deepin.dde-session-ui
        pkgs.deepin.deepin-image-viewer
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

      users.groups.deepin-daemon = { };

      users.users.deepin-daemon = {
        description = "Deepin daemon user";
        group = "deepin-daemon";
        isSystemUser = true;
      };

      services.deepin.deepin-menu.enable = true;
      services.deepin.deepin-turbo.enable = true;
    })

    (lib.mkIf config.services.deepin.deepin-menu.enable {
      services.dbus.packages = [ pkgs.deepin.deepin-menu ];
    })

    (lib.mkIf config.services.deepin.deepin-turbo.enable {
      environment.systemPackages = [ pkgs.deepin.deepin-turbo ];
      systemd.packages = [ pkgs.deepin.deepin-turbo ];
    })

  ];

}
