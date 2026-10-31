# RustDesk unattended Wayland builds

`rustdesk-flutter-unattended-wayland` enables upstream's `drm` and `drm-wake` features for unattended Wayland access using the same stable release as `rustdesk-flutter`.
It inherits the source, Cargo dependencies, Flutter SDK, and Dart lockfiles from that package.
Both variants install the `rustdesk` executable and the same desktop entries, so only one of them should be enabled on a system or user profile.

DRM capture needs a root service running `rustdesk --service`, access to the host's DRM devices, and the `uinput` kernel module for remote input (installing the package does not configure the service nor authentication).
The ID/relay backend is provided by the separate `services.rustdesk-server` module, not the desktop capture service.

The library is loaded from an absolute Nix store path. After `sudo` strips library paths, session subprocesses re-enter the package wrapper so they run the same ELF as the service (required by upstream's IPC peer checks).
The host system has to provide working `sudo`/`su` because binaries copied into the Nix store will not work for this.

## Updating

1. Update `rustdesk-flutter` to the desired stable release, including its source, Cargo dependencies, and Dart lockfiles
2. Check the `LIBDRMTAP_SHA_PINNED` produced by the `build.py` script and update `libdrmtap` to that revision
3. Check the `reenter-wrapper.patch`, the DRM loader path, and the `extended_text` substitution against the new source and inherited lockfile
4. Verify the libdrmtap ABI and the `drm` / `drm-wake` features, then build both variants and run the package version test:

```sh
nix-build -A libdrmtap --no-out-link
nix-build -A rustdesk-flutter --no-out-link
nix-build -A rustdesk-flutter-unattended-wayland --no-out-link
nix-build -A rustdesk-flutter-unattended-wayland.tests.version --no-out-link
```

Manually verify that unattended access actually works before relying on it (both greeter and lock-screen).
