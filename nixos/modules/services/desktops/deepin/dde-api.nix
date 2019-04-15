# dde-api

{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    services.deepin.dde-api = {

      enable = lib.mkEnableOption
        "Services provided by the Deepin Desktop Environment API";

    };

  };


  ###### implementation

  config = lib.mkIf config.services.deepin.dde-api.enable {

    environment.systemPackages = [ pkgs.deepin.dde-api ];

    services.dbus.packages = [ pkgs.deepin.dde-api ];

    systemd.packages = [ pkgs.deepin.dde-api ];

    users.groups.deepin-sound-player = { };

    users.users.deepin-sound-player = {
      description = "Deepin sound player";
      group = "deepin-sound-player";
      isSystemUser = true;
    };

  };

}
