{ config, lib, pkgs, ... }:

let
  cfg = config.services.flatpak;

  flatpakCommand = "${cfg.package}/bin/flatpak";

  manageFlatpaks = pkgs.writeShellScript "manage-flatpaks" ''
    set -eou pipefail

    echo "Ensuring Flathub repository is added..."
    ${flatpakCommand} remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "Installing specified Flatpak packages..."
    for pkg in ${toString cfg.packages}; do
      if ! ${flatpakCommand} info "$pkg" &>/dev/null; then
        echo "Installing Flatpak package: $pkg"
        ${flatpakCommand} install --assumeyes flathub "$pkg"
      else
        echo "Flatpak package already installed: $pkg"
      fi
    done

    ${lib.optionalString cfg.removeUnmanagedPackages ''
      echo "Removing unmanaged Flatpak packages..."
      installed_pkgs=$(${flatpakCommand} list --app --columns=application)
      for pkg in $installed_pkgs; do
        if ! echo "${toString cfg.packages}" | grep -q "$pkg"; then
          echo "Removing Flatpak package: $pkg"
          ${flatpakCommand} uninstall --assumeyes "$pkg"
        fi
      done
    ''}

    ${lib.optionalString cfg.automaticUpdates ''
      echo "Updating all Flatpak packages..."
      ${flatpakCommand} update --assumeyes
    ''}
  '';

in {
  meta = {
    doc = ./flatpak.md;
    maintainers = pkgs.flatpak.meta.maintainers;
  };

  ###### interface
  options = {
    services.flatpak = {
      enable = lib.mkEnableOption "flatpak";

      package = lib.mkPackageOption pkgs "flatpak" { };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = [ "org.blender.Blender" "net.ankiweb.Anki" ];
        description = "List of Flatpak packages to install or update.";
      };

      removeUnmanagedPackages = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to remove Flatpak packages not listed in 'packages'.";
      };

      automaticUpdates = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to automatically update Flatpak packages.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      { assertion = (config.xdg.portal.enable == true);
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

    system.activationScripts.flatpak-setup = ''
      echo "Managing Flatpak packages..."
      ${manageFlatpaks}
    '';

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
