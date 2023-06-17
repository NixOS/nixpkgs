{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.deepin.members;
  };

  ###### interface

  options = {

    services.deepin.app-services = {

      enable = mkEnableOption (lib.mdDoc "Service collection of DDE applications, including dconfig-center");

    };

  };


  ###### implementation

  config = mkIf config.services.deepin.app-services.enable {

    environment.systemPackages = [ pkgs.deepin.dde-app-services ];

    services.dbus.packages = [ pkgs.deepin.dde-app-services ];

    environment.pathsToLink = [ "/share/dsg" ];

  };

}
