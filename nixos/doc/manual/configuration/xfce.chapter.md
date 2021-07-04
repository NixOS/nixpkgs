# Xfce Desktop Environment {#sec-xfce}

To enable the Xfce Desktop Environment, set

```nix
services.xserver.desktopManager.xfce.enable = true;
services.xserver.displayManager.defaultSession = "xfce";
```

Optionally, *picom* can be enabled for nice graphical effects, some
example settings:

```nix
services.picom = {
  enable = true;
  fade = true;
  inactiveOpacity = 0.9;
  shadow = true;
  fadeDelta = 4;
};
```

Some Xfce programs are not installed automatically. To install them
manually (system wide), put them into your
[](#opt-environment.systemPackages) from `pkgs.xfce`.

## Thunar Plugins {#sec-xfce-thunar-plugins .unnumbered}

If you\'d like to add extra plugins to Thunar, add them to
[](#opt-services.xserver.desktopManager.xfce.thunarPlugins).
You shouldn\'t just add them to [](#opt-environment.systemPackages).

## Troubleshooting {#sec-xfce-troubleshooting .unnumbered}

Even after enabling udisks2, volume management might not work. Thunar
and/or the desktop takes time to show up. Thunar will spit out this kind
of message on start (look at `journalctl --user -b`).

```plain
Thunar:2410): GVFS-RemoteVolumeMonitor-WARNING **: remote volume monitor with dbus name org.gtk.Private.UDisks2VolumeMonitor is not supported
```

This is caused by some needed GNOME services not running. This is all
fixed by enabling \"Launch GNOME services on startup\" in the Advanced
tab of the Session and Startup settings panel. Alternatively, you can
run this command to do the same thing.

```ShellSession
$ xfconf-query -c xfce4-session -p /compat/LaunchGNOME -s true
```

A log-out and re-log will be needed for this to take effect.
