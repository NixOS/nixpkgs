{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.flatpak;

  flatpakCommand = "${cfg.package}/bin/flatpak";

  manageFlatpaks = pkgs.writeShellScript "manage-flatpaks" ''
    set -eou pipefail

    ${lib.optionalString (cfg.remote != null) ''
      if ! ${flatpakCommand} remotes | grep -q "^${cfg.remote.name}"; then
        echo "Adding Flatpak remote: ${cfg.remote.name}"
        ${flatpakCommand} remote-add --if-not-exists "${cfg.remote.name}" "${cfg.remote.url}"
      else
        echo "Flatpak remote already exists: ${cfg.remote.name}"
      fi
    ''}

    echo "Installing specified Flatpak packages..."
    for pkg in ${toString cfg.packages}; do
      if ! ${flatpakCommand} info "$pkg" &>/dev/null; then
        echo "Installing Flatpak package: $pkg"
        ${flatpakCommand} install --assumeyes "$pkg"
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

    ${lib.optionalString cfg.update.duringBuild ''
      echo "Updating all Flatpak packages..."
      ${flatpakCommand} update --assumeyes
    ''}
  '';

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

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "org.blender.Blender"
          "net.ankiweb.Anki"
        ];
        description = "List of Flatpak packages to install or update.";
      };

      removeUnmanagedPackages = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to remove Flatpak packages not listed in 'packages'.";
      };

      update = {
        auto = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to automatically update Flatpak packages.";
          };
          onCalendar = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "weekly";
            description = ''
              When to perform automatic updates. Uses systemd calendar format. If null, no timer will be created.
              See systemd.time for more information on the calendar event syntax.
            '';
          };
        };
        duringBuild = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to update Flatpak packages during system rebuild.";
        };
      };

      remotes = lib.mkOption {
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Name of the Flatpak remote.";
              };
              url = lib.mkOption {
                type = lib.types.str;
                description = "URL of the Flatpak remote.";
              };
            };
          }
        );
        default = [
          {
            name = "flathub";
            url = "https://flathub.org/repo/flathub.flatpakrepo";
          }
        ];
        example = [
          {
            name = "flathub";
            url = "https://flathub.org/repo/flathub.flatpakrepo";
          }
          {
            name = "gnome";
            url = "https://sdk.gnome.org/repo/flatpak/gnome-nightly.flatpakrepo";
          }
        ];
        description = "List of Flatpak remotes to add. By default, includes Flathub.";
      };

      removeUnmanagedRemotes = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to remove Flatpak remotes not listed in 'remotes'.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (config.xdg.portal.enable == true);
        message = "To use Flatpak you must enable XDG Desktop Portals with xdg.portal.enable.";
      }
    ];

    environment.systemPackages = [
      cfg.package
      pkgs.fuse3
    ];

    security.polkit.enable = true;

    fonts.fontDir.enable = true;

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
    systemd.tmpfiles.packages = [ cfg.package ];

    environment.profiles = [
      "$HOME/.local/share/flatpak/exports"
      "/var/lib/flatpak/exports"
    ];

    # Activation script for installation and optionally updating during build
    system.activationScripts.flatpak-setup = ''
      set -eou pipefail

      # Get list of configured remote names
      configured_remotes=""
      for remote in ${toString cfg.remotes}; do
        remote_name=$(echo $remote | jq -r .name)
        configured_remotes="$configured_remotes $remote_name"
      done

      ${lib.optionalString cfg.removeUnmanagedRemotes ''
        # Remove remotes that are not in the config
        for existing_remote in $(${flatpakCommand} remotes | cut -f1); do
          if ! echo "$configured_remotes" | grep -q " $existing_remote "; then
            echo "Removing unconfigured Flatpak remote: $existing_remote"
            ${flatpakCommand} remote-delete --force "$existing_remote"
          fi
        done
      ''}

      # Add or update configured remotes
      for remote in ${toString cfg.remotes}; do
        remote_name=$(echo $remote | jq -r .name)
        remote_url=$(echo $remote | jq -r .url)
        if ! ${flatpakCommand} remotes | grep -q "^$remote_name"; then
          echo "Adding Flatpak remote: $remote_name"
          ${flatpakCommand} remote-add --if-not-exists "$remote_name" "$remote_url"
        else
          echo "Flatpak remote already exists: $remote_name"
          # Update the remote URL in case it changed
          ${flatpakCommand} remote-modify --url "$remote_url" "$remote_name"
        fi
      done

      echo "Installing specified Flatpak packages..."
      ${manageFlatpaks}
    '';

    # Systemd service for automatic updates
    systemd.services.flatpak-update = lib.mkIf cfg.update.auto.enable {
      description = "Flatpak package updates";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = [ cfg.package ];
      script = ''
        ${flatpakCommand} update --assumeyes
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    systemd.timers.flatpak-update =
      lib.mkIf (cfg.update.auto.enable && cfg.update.auto.onCalendar != null)
        {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.update.auto.onCalendar;
            Persistent = true;
            Unit = "flatpak-update.service";
          };
        };

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
