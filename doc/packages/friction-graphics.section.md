# Friction {#friction-graphics}

[Friction](https://friction.graphics/) is an open-source vector motion graphics application for creating animations for web and video platforms.

## Wayland support {#friction-graphics-wayland}

Upstream explicitly forces X11 (XCB) on Linux due to incomplete Wayland support (fullscreen does not work, some mouse interactions are broken).
This means the application runs under XWayland by default and does not respect compositor-level HiDPI scaling.

To enable native Wayland support, removing the forced X11 override:

```nix
friction-graphics.override { enableWayland = true; }
```
