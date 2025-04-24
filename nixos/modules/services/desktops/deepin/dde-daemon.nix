{
  config,
  pkgs,
  lib,
  ...
}:
{

  meta = {
    maintainers = lib.teams.deepin.members;
  };

  ###### interface

  options = {

    services.deepin.dde-daemon = {

      enable = lib.mkEnableOption "daemon for handling the deepin session settings";

    };

  };

  ###### implementation

  config = lib.mkIf config.services.deepin.dde-daemon.enable {

    environment.systemPackages = [ pkgs.deepin.dde-daemon ];

    services.dbus.packages = [ pkgs.deepin.dde-daemon ];

    services.udev.packages = [ pkgs.deepin.dde-daemon ];

    systemd.packages = [ pkgs.deepin.dde-daemon ];

    environment.pathsToLink = [ "/lib/deepin-daemon" ];

  };

}
