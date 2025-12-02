{ config, lib, ... }:
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
        [XDG Autostart specification](https://specifications.freedesktop.org/autostart-spec/latest).
      '';
    };
  };

  config = lib.mkIf config.xdg.autostart.enable {
    environment.pathsToLink = [
      "/etc/xdg/autostart"
    ];
  };

}
