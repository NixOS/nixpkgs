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
        pkgs.deepin.dde-daemon
      ];

      services.dbus.packages = [
        pkgs.deepin.dde-daemon
      ];

      systemd.packages = [
        pkgs.deepin.dde-daemon
      ];

      users.groups.dde-daemon = { };

      users.users.dde-daemon = {
        description = "Deepin daemon user";
        group = "dde-daemon";
        isSystemUser = true;
      };
    })

  ];

}
