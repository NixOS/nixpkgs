# GNOME Desktop {#chap-gnome}

GNOME provides a simple, yet full-featured desktop environment with a focus on productivity. Its Mutter compositor supports both Wayland and X server, and the GNOME Shell user interface is fully customizable by extensions.

## Enabling GNOME {#sec-gnome-enable}

All of the core apps, optional apps, games, and core developer tools from GNOME are available.

To enable the GNOME desktop use:

```nix
{
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
}
```

::: {.note}
While it is not strictly necessary to use GDM as the display manager with GNOME, it is recommended, as some features such as screen lock [might not work](#sec-gnome-faq-can-i-use-lightdm-with-gnome) without it.
:::

The default applications used in NixOS are very minimal, inspired by the defaults used in [gnome-build-meta](https://gitlab.gnome.org/GNOME/gnome-build-meta/blob/40.0/elements/core/meta-gnome-core-utilities.bst).

### GNOME without the apps {#sec-gnome-without-the-apps}

If you’d like to only use the GNOME desktop and not the apps, you can disable them with:

```nix
{
  services.gnome.core-utilities.enable = false;
}
```

and none of them will be installed.

If you’d only like to omit a subset of the core utilities, you can use
[](#opt-environment.gnome.excludePackages).
Note that this mechanism can only exclude core utilities, games and core developer tools.

### Disabling GNOME services {#sec-gnome-disabling-services}

It is also possible to disable many of the [core services](https://github.com/NixOS/nixpkgs/blob/b8ec4fd2a4edc4e30d02ba7b1a2cc1358f3db1d5/nixos/modules/services/x11/desktop-managers/gnome.nix#L329-L348). For example, if you do not need indexing files, you can disable Tracker with:

```nix
{
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;
}
```

Note, however, that doing so is not supported and might break some applications. Notably, GNOME Music cannot work without Tracker.

### GNOME games {#sec-gnome-games}

You can install all of the GNOME games with:

```nix
{
  services.gnome.games.enable = true;
}
```

### GNOME core developer tools {#sec-gnome-core-developer-tools}

You can install GNOME core developer tools with:

```nix
{
  services.gnome.core-developer-tools.enable = true;
}
```

## Enabling GNOME Flashback {#sec-gnome-enable-flashback}

GNOME Flashback provides a desktop environment based on the classic GNOME 2 architecture. You can enable the default GNOME Flashback session, which uses the Metacity window manager, with:

```nix
{
  services.xserver.desktopManager.gnome.flashback.enableMetacity = true;
}
```

It is also possible to create custom sessions that replace Metacity with a different window manager using [](#opt-services.xserver.desktopManager.gnome.flashback.customSessions).

The following example uses `xmonad` window manager:

```nix
{
  services.xserver.desktopManager.gnome.flashback.customSessions = [
    {
      wmName = "xmonad";
      wmLabel = "XMonad";
      wmCommand = "${pkgs.haskellPackages.xmonad}/bin/xmonad";
      enableGnomePanel = false;
    }
  ];
}
```

## Icons and GTK Themes {#sec-gnome-icons-and-gtk-themes}

Icon themes and GTK themes don’t require any special option to install in NixOS.

You can add them to [](#opt-environment.systemPackages) and switch to them with GNOME Tweaks.
If you’d like to do this manually in dconf, change the values of the following keys:

```
/org/gnome/desktop/interface/gtk-theme
/org/gnome/desktop/interface/icon-theme
```

in `dconf-editor`

## Shell Extensions {#sec-gnome-shell-extensions}

Most Shell extensions are packaged under the `gnomeExtensions` attribute.
Some packages that include Shell extensions, like `gpaste`, don’t have their extension decoupled under this attribute.

You can install them like any other package:

```nix
{
  environment.systemPackages = [
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    gnomeExtensions.mpris-indicator-button
  ];
}
```

Unfortunately, we lack a way for these to be managed in a completely declarative way.
So you have to enable them manually with an Extensions application.
It is possible to use a [GSettings override](#sec-gnome-gsettings-overrides) for this on `org.gnome.shell.enabled-extensions`, but that will only influence the default value.

## GSettings Overrides {#sec-gnome-gsettings-overrides}

Majority of software building on the GNOME platform use GLib’s [GSettings](https://developer.gnome.org/gio/unstable/GSettings.html) system to manage runtime configuration. For our purposes, the system consists of XML schemas describing the individual configuration options, stored in the package, and a settings backend, where the values of the settings are stored. On NixOS, like on most Linux distributions, dconf database is used as the backend.

[GSettings vendor overrides](https://developer.gnome.org/gio/unstable/GSettings.html#id-1.4.19.2.9.25) can be used to adjust the default values for settings of the GNOME desktop and apps by replacing the default values specified in the XML schemas. Using overrides will allow you to pre-seed user settings before you even start the session.

::: {.warning}
Overrides really only change the default values for GSettings keys so if you or an application changes the setting value, the value set by the override will be ignored. Until [NixOS’s dconf module implements changing values](https://github.com/NixOS/nixpkgs/issues/54150), you will either need to keep that in mind and clear the setting from the backend using `dconf reset` command when that happens, or use the [module from home-manager](https://nix-community.github.io/home-manager/options.html#opt-dconf.settings).
:::

You can override the default GSettings values using the
[](#opt-services.xserver.desktopManager.gnome.extraGSettingsOverrides) option.

Take note that whatever packages you want to override GSettings for, you need to add them to
[](#opt-services.xserver.desktopManager.gnome.extraGSettingsOverridePackages).

You can use `dconf-editor` tool to explore which GSettings you can set.

### Example {#sec-gnome-gsettings-overrides-example}

```nix
{
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverrides = ''
      # Change default background
      [org.gnome.desktop.background]
      picture-uri='file://${pkgs.nixos-artwork.wallpapers.mosaic-blue.gnomeFilePath}'

      # Favorite apps in gnome-shell
      [org.gnome.shell]
      favorite-apps=['org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop']
    '';

    extraGSettingsOverridePackages = [
      pkgs.gsettings-desktop-schemas # for org.gnome.desktop
      pkgs.gnome-shell # for org.gnome.shell
    ];
  };
}
```

## Frequently Asked Questions {#sec-gnome-faq}

### Can I use LightDM with GNOME? {#sec-gnome-faq-can-i-use-lightdm-with-gnome}

Yes you can, and any other display-manager in NixOS.

However, it doesn’t work correctly for the Wayland session of GNOME Shell yet, and
won’t be able to lock your screen.

See [this issue.](https://github.com/NixOS/nixpkgs/issues/56342)
