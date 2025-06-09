# OpenGL {#sec-opengl}

OpenGL support varies depending on which hardware is used and which drivers are available and loaded.

Broadly, we support both GL vendors: Mesa and NVIDIA.

## NixOS Desktop {#nixos-desktop}

The NixOS desktop or other non-headless configurations are the primary target for OpenGL libraries and applications. The current solution for discovering which drivers are available is based on [libglvnd](https://gitlab.freedesktop.org/glvnd/libglvnd). `libglvnd` performs "vendor-neutral dispatch", trying a variety of techniques to find the system's GL implementation. In practice, this will be either via standard GLX for X11 users or EGL for Wayland users, and supporting either NVIDIA or Mesa extensions.

## Nix on GNU/Linux {#nix-on-gnulinux}

If you are using a non-NixOS GNU/Linux/X11 desktop with free software video drivers, consider launching OpenGL-dependent programs from Nixpkgs with Nixpkgs versions of `libglvnd` and `mesa` in `LD_LIBRARY_PATH`. For Mesa drivers, the Linux kernel version doesn't have to match nixpkgs.

For proprietary video drivers, you might have luck with also adding the corresponding video driver package.
