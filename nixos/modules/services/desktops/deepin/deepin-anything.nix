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

  options = {

    services.deepin.deepin-anything = {

      enable = lib.mkEnableOption "deepin anything file search tool";

    };

  };

  config = lib.mkIf config.services.deepin.dde-api.enable {
    environment.systemPackages = [ pkgs.deepin.deepin-anything ];

    services.dbus.packages = [ pkgs.deepin.deepin-anything ];

    users.groups.deepin-anything = { };

    users.users.deepin-anything = {
      description = "Deepin Anything Server";
      home = "/var/lib/deepin-anything";
      createHome = true;
      group = "deepin-anything";
      isSystemUser = true;
    };

    boot.extraModulePackages = [ config.boot.kernelPackages.deepin-anything-module ];
    boot.kernelModules = [ "vfs_monitor" ];
  };

}
