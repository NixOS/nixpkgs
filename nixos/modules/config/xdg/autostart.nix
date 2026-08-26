{ config, lib, ... }:
{
  meta = {
    teams = [ lib.teams.freedesktop ];
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
    # FIXME this does not actually work because "/etc/xdg" is linked
    # unconditionally in `nixos/modules/config/system-path.nix`
    environment.pathsToLink = [
      "/etc/xdg/autostart"
    ];
  };
}
