# Flatpak {#module-services-flatpak}

*Source:* {file}`modules/services/desktop/flatpak.nix`

*Upstream documentation:* <https://github.com/flatpak/flatpak/wiki>

Flatpak is a system for building, distributing, and running sandboxed desktop
applications on Linux.

To enable Flatpak, add the following to your {file}`configuration.nix`:
```nix
{
  services.flatpak.enable = true;
}
```

For the sandboxed apps to work correctly, desktop integration portals need to
be installed. If you run GNOME, this will be handled automatically for you;
in other cases, you will need to add something like the following to your
{file}`configuration.nix`:
```nix
{
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";
}
```

## Declarative Flatpak management {#module-services-flatpak-declarative-manage}
NixOS now supports integrated management of Flatpak packages. You can specify
Flatpak packages to be installed or removed through your {file}`configuration.nix`:
```nix
{
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        url = "https://flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "gnome";
        url = "https://sdk.gnome.org/repo/flatpak/gnome-nightly.flatpakrepo";
      }
    ];
    packages = [ "org.blender.Blender" "net.ankiweb.Anki" ];
    removeUnmanagedPackages = true;
    removeUnmanagedRemotes = true;
    update = {
      auto = {
        enable = true;
        onCalendar = "weekly";
      };
      duringBuild = false;
    };
  };
}
```

This example configuration will:
- Enable Flatpak
- Add the specified Flatpak remotes (Flathub and GNOME nightly in this example)
- Ensure the specified packages are installed (Blender and Anki in this example)
- Remove any Flatpak packages not listed in the `packages` option (if `removeUnmanagedPackages` is true)
- Remove any Flatpak remotes not listed in the `remotes` option (if `removeUnmanagedRemotes` is true)
- Enable automatic weekly updates of Flatpak packages
- Disable package updates when building your system

Important notes:
- Package versions are managed by Flatpak's servers, not nixpkgs.
- The `removeUnmanagedPackages` option defaults to `false`.
- The `removeUnmanagedRemotes` option defaults to `false`.
- The `update.auto.enable` option defaults to `false`. When set to `true`, it allows automatic updates of installed Flatpak packages.
- The `update.auto.onCalendar` option uses systemd calendar syntax. If not set, no timer will be created even if `update.auto.enable` is `true`.
- The `update.duringBuild` option defaults to `false`. When set to `true`, it updates Flatpak packages during system rebuild.
- The `remotes` option defaults to including Flathub, the main repository for Flatpak applications.

Be aware that while Flatpak packages are managed through NixOS, they operate in a somewhat separate environment. If you encounter issues with a Flatpak package:
- First, check if the issue is related to NixOS configuration, such as missing portals or system dependencies.
- If the problem seems to be with the Flatpak package itself, then it's best to check with the upstream project.

Remember that the NixOS Flatpak integration might also have its own quirks, so consider if the problem could be related to how NixOS is managing Flatpak when troubleshooting.

## Manual Flatpak management {#module-services-flatpak-manual-manage}
If you prefer to manage Flatpak packages manually, you can still do so.

First, you will need to add a repository, for example,
[Flathub](https://github.com/flatpak/flatpak/wiki),
either using the following commands:

```ShellSession
$ flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
$ flatpak update
```
or by opening the
[repository file](https://flathub.org/repo/flathub.flatpakrepo) in GNOME Software.

Then, you can search and install programs:

```ShellSession
$ flatpak search bustle
$ flatpak install flathub org.freedesktop.Bustle
$ flatpak run org.freedesktop.Bustle
```

GNOME Software and KDE Discover offer a graphical interface for these tasks.

Note: When using NixOS-integrated package management:
- Manually installed packages may be removed if `removeUnmanagedPackages` is set to `true` and the package is not listed in the `packages` option.
- Manually added remotes may be removed if `removeUnmanagedRemotes` is set to `true` and the remote is not listed in the `remotes` option.
- If automatic updates are disabled, you will need to manually update your Flatpak packages using the `flatpak update` command.
