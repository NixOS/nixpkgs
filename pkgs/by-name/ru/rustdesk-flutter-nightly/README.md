# RustDesk development builds

This variant of RustDesk includes upstream's unreleased `drm` and `drm-wake` features for unattended Wayland access, while `rustdesk-flutter` remains the stable version.
Both variants install the `rustdesk` executable and the same desktop entries, so only one of them should be enabled on a system or user profile.

DRM capture needs a root service running `rustdesk --service`, access to the host's DRM devices, and the `uinput` kernel module for remote input (installing the package does not configure the service nor authentication).
The ID/relay backend is provided by the separate `services.rustdesk-server` module, not the desktop capture service.

The library is loaded from an absolute Nix store path. After `sudo` strips library paths, session subprocesses re-enter the package wrapper so they run the same ELF as the service (required by upstream's IPC peer checks).
The host system has to provide working `sudo`/`su` because binaries copied into the Nix store will not work for this.

## Updating

1. Pin an upstream (RustDesk) commit and its submodules
2. Follow Nixpkgs' conventions: `<last stable release>-unstable-<commit date>`
3. Check the `LIBDRMTAP_SHA_PINNED` produced by the `build.py` script and update `libdrmtap` to that revision
4. Verify the ABI + `drm`/`drm-wake` features
5. Starting from the new source's `flutter/pubspec.lock`, add the package's `extended_text` to `flutter/pubspec.yaml`, and resolve the lock with the packaged Flutter SDK version (currently `3.29.3`)
6. Convert the resolved lock by using e.g. `yq . flutter/pubspec.lock` to `pubspec.lock.json` and review the changes to SDK dependencies and locked Git revisions
7. Refresh the Git hashes from the lock's `resolved-ref` values using the Nixpkgs helper from the repo's root:

```sh
pkgs/development/compilers/dart/fetch-git-hashes.py \
--input pkgs/by-name/ru/rustdesk-flutter-nightly/pubspec.lock.json \
--output pkgs/by-name/ru/rustdesk-flutter-nightly/git-hashes.json
```
8. Refresh `cargoDeps.hash`, check the packaging patches against the new source, and run:

```sh
nix-build -A libdrmtap --no-out-link
nix-build -A rustdesk-flutter-nightly --no-out-link
nix-build -A rustdesk-flutter-nightly.tests.version --no-out-link
```

Manually verify that unattended access actually works before relying on it (both greeter and lock-screen).
