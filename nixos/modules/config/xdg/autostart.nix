{ config, lib, ... }:
{
  meta = {
    teams = [ lib.teams.freedesktop ];
  };

  options.xdg.autostart = {
    enable =
      lib.mkEnableOption "auto-starting of desktop applications according to the [XDG Autostart specification](https://specifications.freedesktop.org/autostart-spec/latest)."
      // lib.mkOption {
        default = true;
      };
    install =
      lib.mkEnableOption ''
        install desktop files following the [XDG Autostart specification](https://specifications.freedesktop.org/autostart-spec/latest) into `/etc/xdg/autostart/`.

        These are handled by your desktop environment or [`systemd-xdg-autostart-generator`](https://www.freedesktop.org/software/systemd/man/latest/systemd-xdg-autostart-generator.html).
      ''
      // lib.mkOption {
        default = true;
      };
  };

  config = {
    # FIXME this does not actually work because "/etc/xdg" is linked
    # unconditionally in `nixos/modules/config/system-path.nix`
    environment.pathsToLink = lib.mkIf config.xdg.autostart.install [
      "/etc/xdg/autostart"
    ];

    # On by default
    systemd.user.generators.systemd-xdg-autostart-generator = lib.mkIf (!config.xdg.autostart.enable) (
      lib.mkDefault "/dev/null"
    );
  };
}
