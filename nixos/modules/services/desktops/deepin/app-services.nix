{ config, pkgs, lib, ... }:
{

  meta = {
    maintainers = lib.teams.deepin.members;
  };

  ###### interface

  options = {

    services.deepin.app-services = {

      enable = lib.mkEnableOption "service collection of DDE applications, including dconfig-center";

    };

  };


  ###### implementation

  config = lib.mkIf config.services.deepin.app-services.enable {

    users.groups.dde-dconfig-daemon = { };
    users.users.dde-dconfig-daemon = {
      description = "Dconfig daemon user";
      home = "/var/lib/dde-dconfig-daemon";
      createHome = true;
      group = "dde-dconfig-daemon";
      isSystemUser = true;
    };

    environment.systemPackages = [ pkgs.deepin.dde-app-services ];
    systemd.packages = [ pkgs.deepin.dde-app-services ];
    services.dbus.packages = [ pkgs.deepin.dde-app-services ];

    environment.pathsToLink = [ "/share/dsg" ];

  };

}
