{ config, lib, pkgs, ... }:

with lib;
{
  meta = {
    maintainers = teams.freedesktop.members;
  };

  options = {
    xdg.icons.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        [XDG Icon Theme specification](https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html).
      '';
    };
  };

  config = mkIf config.xdg.icons.enable {
    environment.pathsToLink = [
      "/share/icons"
      "/share/pixmaps"
    ];

    environment.systemPackages = [
      # Empty icon theme that contains index.theme file describing directories
      # where toolkits should look for icons installed by apps.
      pkgs.hicolor-icon-theme
    ];

    # libXcursor looks for cursors in XCURSOR_PATH
    # it mostly follows the spec for icons
    # See: https://www.x.org/releases/current/doc/man/man3/Xcursor.3.xhtml Themes

    # These are preferred so they come first in the list
    environment.sessionVariables.XCURSOR_PATH = [
      "$HOME/.icons"
      "$HOME/.local/share/icons"
    ];

    environment.profileRelativeSessionVariables.XCURSOR_PATH = [
      "/share/icons"
      "/share/pixmaps"
    ];
  };

}
