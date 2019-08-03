{ config, lib, ... }:

with lib;
{
  options = {
    xdg.menus.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the 
        <link xlink:href="https://specifications.freedesktop.org/menu-spec/menu-spec-latest.html">XDG Desktop Menu specification</link>.
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
