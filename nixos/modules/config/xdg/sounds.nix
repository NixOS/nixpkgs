{ config, lib, pkgs, ... }:
{
  meta = {
    maintainers = lib.teams.freedesktop.members;
  };

  options = {
    xdg.sounds.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to install files to support the
        [XDG Sound Theme specification](https://www.freedesktop.org/wiki/Specifications/sound-theme-spec/).
      '';
    };
  };

  config = lib.mkIf config.xdg.sounds.enable {
    environment.systemPackages = [
      pkgs.sound-theme-freedesktop
    ];

    environment.pathsToLink = [
      "/share/sounds"
    ];
  };

}
