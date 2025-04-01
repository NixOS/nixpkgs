# flatpak service.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.flatpak;
in
{
  meta = {
    doc = ./flatpak.md;
    maintainers = pkgs.flatpak.meta.maintainers;
  };

  ###### interface
  options = {
    services.flatpak = {
      enable = lib.mkEnableOption "flatpak";

      package = lib.mkPackageOption pkgs "flatpak" { };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = (config.xdg.portal.enable == true);
        message = "To use Flatpak you must enable XDG Desktop Portals with xdg.portal.enable.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    security.polkit.enable = true;

    fonts.fontDir.enable = true;

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
    systemd.tmpfiles.packages = [ cfg.package ];

    environment.profiles = [
      "$HOME/.local/share/flatpak/exports"
      "/var/lib/flatpak/exports"
    ];

    # It has been possible since https://github.com/flatpak/flatpak/releases/tag/1.3.2
    # to build a SELinux policy module.

    # TODO: use sysusers.d
    users.users.flatpak = {
      description = "Flatpak system helper";
      group = "flatpak";
      isSystemUser = true;
    };

    users.groups.flatpak = { };
  };
}
