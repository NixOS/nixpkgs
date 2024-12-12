# glycin-loaders {#glycin-loaders-hook}

[Glycin](https://gitlab.gnome.org/GNOME/glycin) is a library for sandboxed and extendable image loading.

For most applications using it, individual image formats are loaded through binaries provided by `glycin-loaders`. The paths of these loaders must be injected into the environment via [`wrapGAppsHook`](#ssec-gnome-hooks). Likewise, `glycin` itself requires a patch to its internal sandbox in order to find certain binaries and understand the `/nix/store` model.

In Nixpkgs, this is all handled through the `glycin-loaders` setup hook.

## Example code snippet {#glycin-loaders-hook-example-code-snippet}

```nix
{
  lib,
  rustPlatform,
  glycin-loaders,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage {
  # ...

  cargoHash = "...";

  nativeBuildInputs = [ wrapGAppsHook4 ];

  buildInputs = [ glycin-loaders ];

  # ...
}
```

## Variables controlling glycin-loaders {#glycin-loaders-hook-variables-controlling}

### `glycinCargoDepsPath` {#glycin-cargo-deps-path}

Path to a directory containing the `glycin` crate to patch. Defaults to the crate directory created by `cargoSetupHook`, or `./vendor/`.

### `dontPatchGlycinLoaders` {#dont-patch-glycin}

Disables the patching of `glycin` crates in your Cargo dependencies.

### `dontWrapGlycinLoaders` {#dont-wrap-glycin}

Disable adding the Glycin loaders path `XDG_DATA_DIRS` with `wrapGAppsHook`.
