{ config, lib, ... }:

with lib;
{
  meta = {
    maintainers = teams.freedesktop.members;
  };

  options = {
    xdg.menus.enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to install files to support the
        [XDG Desktop Menu specification](https://specifications.freedesktop.org/menu-spec/menu-spec-latest.html).
      '';
    };
  };

  config = mkIf config.xdg.menus.enable {
    environment.pathsToLink = [
      "/share/applications"
      "/share/desktop-directories"
      "/etc/xdg/menus"
      "/etc/xdg/menus/applications-merged"
    ];
  };

}
