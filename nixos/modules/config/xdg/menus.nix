{ config, lib, ... }:
{
  meta = {
    teams = [ lib.teams.freedesktop ];
  };

  options = {
    xdg.menus.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        [XDG Desktop Menu specification](https://specifications.freedesktop.org/menu-spec/latest).
      '';
    };
  };

  config = lib.mkIf config.xdg.menus.enable {
    environment.pathsToLink = [
      "/share/applications"
      "/share/desktop-directories"
      "/etc/xdg/menus"
      "/etc/xdg/menus/applications-merged"
    ];
  };

}
