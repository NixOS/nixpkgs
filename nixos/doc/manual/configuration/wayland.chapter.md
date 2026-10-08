# Wayland {#sec-wayland}

While X11 (see [](#sec-x11)) is still the primary display technology
on NixOS, Wayland support is steadily improving. Where X11 separates the
X Server and the window manager, on Wayland those are combined: a
Wayland Compositor is like an X11 window manager, but also embeds the
Wayland 'Server' functionality. This means it is sufficient to install
a Wayland Compositor such as sway without separately enabling a Wayland
server:

```nix
{ programs.sway.enable = true; }
```

This installs the sway compositor along with some essential utilities.
Now you can start sway from the TTY console.

If you are using a wlroots-based compositor, like sway, and want to be
able to share your screen, make sure to configure Pipewire using
[](#opt-services.pipewire.enable)
and related options.

For more helpful tips and tricks, see the
[wiki page about Sway](https://wiki.nixos.org/wiki/Sway).
