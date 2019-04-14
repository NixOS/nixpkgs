# deepin-menu

{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    services.deepin.deepin-menu = {

      enable = lib.mkEnableOption
        "DBus service for unified menus in Deepin Desktop Environment";

    };

  };


  ###### implementation

  config = lib.mkIf config.services.deepin.deepin-menu.enable {

    services.dbus.packages = [ pkgs.deepin.deepin-menu ];

  };

}
