# flatpak service.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.flatpak;
in {
  meta = {
    doc = ./flatpak.xml;
    maintainers = pkgs.flatpak.meta.maintainers;
  };

  ###### interface
  options = {
    services.flatpak = {
      enable = mkEnableOption "flatpak";

      extraPortals = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          List of additional portals to add to path. Portals allow interaction
          with system, like choosing files or taking screenshots. At minimum,
          a desktop portal implementation should be listed. GNOME already
          adds <package>xdg-desktop-portal-gtk</package>; for KDE, there
          is <package>xdg-desktop-portal-kde</package>. Other desktop
          environments will probably want to do the same.
        '';
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.flatpak ];

    services.dbus.packages = [ pkgs.flatpak pkgs.xdg-desktop-portal ] ++ cfg.extraPortals;

    systemd.packages = [ pkgs.flatpak pkgs.xdg-desktop-portal ] ++ cfg.extraPortals;

    environment.profiles = [
      "$HOME/.local/share/flatpak/exports"
      "/var/lib/flatpak/exports"
    ];

    environment.variables = {
      XDG_DESKTOP_PORTAL_PATH = map (p: "${p}/share/xdg-desktop-portal/portals") cfg.extraPortals;
    };
  };
}
