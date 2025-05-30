{
  config,
  lib,
  pkgs,
  ...
}:
{
  meta = {
    maintainers = lib.teams.freedesktop.members;
  };

  options = {
    xdg.icons.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        [XDG Icon Theme specification](https://specifications.freedesktop.org/icon-theme-spec/latest).
      '';
    };
    xdg.icons.fallbackCursorThemes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Names of the fallback cursor themes, in order of preference, to be used when no other icon source can be found.
        Set to `[]` to disable the fallback entirely.
      '';
    };
  };

  config = lib.mkIf config.xdg.icons.enable {
    environment.pathsToLink = [
      "/share/icons"
      "/share/pixmaps"
    ];

    environment.systemPackages =
      [
        # Empty icon theme that contains index.theme file describing directories
        # where toolkits should look for icons installed by apps.
        pkgs.hicolor-icon-theme
      ]
      ++ lib.optionals (config.xdg.icons.fallbackCursorThemes != [ ]) [
        (pkgs.writeTextFile {
          name = "fallback-cursor-theme";
          text = ''
            [Icon Theme]
            Inherits=${lib.concatStringsSep "," config.xdg.icons.fallbackCursorThemes}
          '';
          destination = "/share/icons/default/index.theme";
        })
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
