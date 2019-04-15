# deepin-turbo

{ config, pkgs, lib, ... }:

{

  ###### interface

  options = {

    services.deepin.deepin-turbo = {

      enable = lib.mkEnableOption "
        Turbo service for the Deepin Desktop Environment. It is a
        daemon that helps to launch applications faster.
      ";

    };

  };


  ###### implementation

  config = lib.mkIf config.services.deepin.deepin-turbo.enable {

    environment.systemPackages = [ pkgs.deepin.deepin-turbo ];

    systemd.packages = [ pkgs.deepin.deepin-turbo ];

  };

}
