{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.xdg.autostart;
in
{
  meta = {
    maintainers = lib.teams.freedesktop.members;
  };

  options = {
    xdg.autostart.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        [XDG Autostart specification](https://specifications.freedesktop.org/autostart-spec/autostart-spec-latest.html).
      '';
    };
    xdg.autostart.packages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = ''
        Autostart applications.

        All .desktop files in share/applications are added.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [
      "/etc/xdg/autostart"
    ];
    environment.etc = lib.mkIf (cfg.packages != [ ]) {
      "xdg/autostart".source = pkgs.symlinkJoin {
        name = "autostart";
        paths = map (p: "${p}/share/applications") cfg.packages;
      };
    };
  };
}
