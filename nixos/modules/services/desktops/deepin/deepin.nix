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
        pkgs.deepin.dde-dock
        pkgs.deepin.dde-session-ui
        pkgs.deepin.deepin-image-viewer
        pkgs.deepin.deepin-screenshot
      ];

      services.dbus.packages = [
        pkgs.deepin.dde-api
        pkgs.deepin.dde-calendar
        pkgs.deepin.dde-daemon
        pkgs.deepin.dde-dock
        pkgs.deepin.dde-session-ui
        pkgs.deepin.deepin-image-viewer
        pkgs.deepin.deepin-screenshot
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

      environment.etc = {
        "polkit-1/localauthority/10-vendor.d/com.deepin.api.device.pkla".source = "${pkgs.deepin.dde-api}/etc/polkit-1/localauthority/10-vendor.d/com.deepin.api.device.pkla";
        "polkit-1/localauthority/10-vendor.d/com.deepin.daemon.Accounts.pkla".source = "${pkgs.deepin.dde-daemon}/etc/polkit-1/localauthority/10-vendor.d/com.deepin.daemon.Accounts.pkla";
        "polkit-1/localauthority/10-vendor.d/com.deepin.daemon.Grub2.pkla".source = "${pkgs.deepin.dde-daemon}/etc/polkit-1/localauthority/10-vendor.d/com.deepin.daemon.Grub2.pkla";
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
