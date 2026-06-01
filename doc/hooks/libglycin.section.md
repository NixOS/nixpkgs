# libglycin {#libglycin-hooks}

[Glycin](https://gitlab.gnome.org/GNOME/glycin) is a library for sandboxed and extendable image loading.

[]{#libglycin-setup-hook} For most applications using it, individual image formats are loaded through binaries provided by `glycin-loaders`. The paths of these loaders must be injected into the environment, e.g. using [`wrapGAppsHook`](#ssec-gnome-hooks). `libglycin.setupHook` will do that.

[]{#libglycin-patch-vendor-hook} Additionally, for Rust projects `glycin` Rust crate itself requires a patch to become self-contained. `libglycin.patchVendorHook` will do that. This is not needed for projects using the ELF library from `libglycin` package.

## Example code snippet {#libglycin-hooks-example-code-snippet}

```nix
{
  lib,
  rustPlatform,
  libglycin,
  glycin-loaders,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage {
  # ...

  cargoHash = "...";

  nativeBuildInputs = [
    wrapGAppsHook4
    libglycin.patchVendorHook
  ];

  buildInputs = [
    libglycin.setupHook
    glycin-loaders
  ];

  # ...
}
```

## Variables controlling glycin-loaders {#libglycin-hook-variables-controlling}

### `glycinCargoDepsPath` {#glycin-cargo-deps-path}

Path to a directory containing the `glycin` crate to patch. Defaults to the crate directory created by `cargoSetupHook`, or `./vendor/`.

### `dontWrapGlycinLoaders` {#glycin-dont-wrap}

Disable adding the Glycin loaders path `XDG_DATA_DIRS` with `wrapGAppsHook`.
