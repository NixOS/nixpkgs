{ config, lib, ... }:

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
        <link xlink:href="https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html">XDG Icon Theme specification</link>.
      '';
    };
  };

  config = mkIf config.xdg.icons.enable {
    environment.pathsToLink = [
      "/share/icons"
      "/share/pixmaps"
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
