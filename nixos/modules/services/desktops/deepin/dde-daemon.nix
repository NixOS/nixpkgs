# dde-daemon

{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    services.deepin.dde-daemon = {

      enable = lib.mkEnableOption
        "A daemon for handling Deepin Desktop Environment session settings";

    };

  };


  ###### implementation

  config = lib.mkIf config.services.deepin.dde-daemon.enable {

    environment.systemPackages = [ pkgs.deepin.dde-daemon ];

    services.dbus.packages = [ pkgs.deepin.dde-daemon ];

    systemd.packages = [ pkgs.deepin.dde-daemon ];

    users.groups.dde-daemon = { };

    users.users.dde-daemon = {
      description = "Deepin daemon user";
      group = "dde-daemon";
      isSystemUser = true;
    };

  };

}
