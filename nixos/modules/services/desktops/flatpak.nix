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

      guiPackages = mkOption {
        internal = true;
        type = types.listOf types.package;
        default = [];
        example = literalExample "[ pkgs.gnome3.gnome-software ]";
        description = ''
          Packages that provide an interface for flatpak
          (like gnome-software) that will be automatically available
          to all users when flatpak is enabled.
        '';
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {

    assertions = [
      { assertion = (config.xdg.portal.enable == true);
        message = "To use Flatpak you must enable XDG Desktop Portals with xdg.portal.enable.";
      }
    ];

    environment.systemPackages = [ pkgs.flatpak ] ++ cfg.guiPackages;

    services.dbus.packages = [ pkgs.flatpak ];

    systemd.packages = [ pkgs.flatpak ];

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
