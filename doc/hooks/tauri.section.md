# cargo-tauri.hook {#tauri-hook}

[Tauri](https://tauri.app/) is a framework for building smaller, faster, and
more secure desktop applications with a web frontend.

In Nixpkgs, `cargo-tauri.hook` overrides the default build and install phases.

## Example code snippet {#tauri-hook-example-code-snippet}

```nix
{
  lib,
  stdenv,
  rustPlatform,
  fetchNpmDeps,
  cargo-tauri,
  darwin,
  glib-networking,
  libsoup,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_0,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  # . . .

  cargoHash = "...";

  # Assuming our app's frontend uses `npm` as a package manager
  npmDeps = fetchNpmDeps {
    name = "${pname}-npm-deps-${version}";
    inherit src;
    hash = "...";
  };

  nativeBuildInputs = [
    # Pull in our main hook
    cargo-tauri.hook

    # Setup npm
    nodejs
    npmHooks.npmConfigHook

    # Make sure we can find our libraries
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      glib-networking # Most Tauri apps need networking
      libsoup
      webkitgtk_4_0
    ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        AppKit
        CoreServices
        Security
        WebKit
      ]
    );

  # Set our Tauri source directory
  cargoRoot = "src-tauri";
  # And make sure we build there too
  buildAndTestSubdir = cargoRoot;

  # . . .
}
```

## Variables controlling cargo-tauri {#tauri-hook-variables-controlling}

### Tauri Exclusive Variables {#tauri-hook-exclusive-variables}

#### `tauriBuildFlags` {#tauri-build-flags}

Controls the flags passed to `cargo tauri build`.

#### `tauriBundleType` {#tauri-bundle-type}

The [bundle type](https://tauri.app/v1/guides/building/) to build.

#### `dontTauriBuild` {#dont-tauri-build}

Disables using `tauriBuildHook`.

#### `dontTauriInstall` {#dont-tauri-install}

Disables using `tauriInstallPostBuildHook` and `tauriInstallHook`.

### Honored Variables {#tauri-hook-honored-variables}

Along with those found in [](#compiling-rust-applications-with-cargo), the
following variables used by `cargoBuildHook` and `cargoInstallHook` are honored
by the cargo-tauri setup hook.

- `buildAndTestSubdir`
- `cargoBuildType`
- `cargoBuildNoDefaultFeatures`
- `cargoBuildFeatures`
