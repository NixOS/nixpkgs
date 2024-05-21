{ config, lib, ... }:

with lib;
{
  meta = {
    maintainers = teams.freedesktop.members;
  };

  options = {
    xdg.autostart.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        [XDG Autostart specification](https://specifications.freedesktop.org/autostart-spec/autostart-spec-latest.html).
      '';
    };
  };

  config = mkIf config.xdg.autostart.enable {
    environment.pathsToLink = [
      "/etc/xdg/autostart"
    ];
  };

}
