{ config, lib, pkgs, ... }:

with lib;
{
  meta = {
    maintainers = teams.freedesktop.members;
  };

  options = {
    xdg.sounds.enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to install files to support the
        [XDG Sound Theme specification](https://www.freedesktop.org/wiki/Specifications/sound-theme-spec/).
      '';
    };
  };

  config = mkIf config.xdg.sounds.enable {
    environment.systemPackages = [
      pkgs.sound-theme-freedesktop
    ];

    environment.pathsToLink = [
      "/share/sounds"
    ];
  };

}
