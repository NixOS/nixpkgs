{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri,
  darwin,
  glib-networking,
  libsoup,
  openssl,
  pkg-config,
  webkitgtk,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage rec {
  pname = "test-app";
  inherit (cargo-tauri) version src;

  # Basic example provided by upstream
  sourceRoot = "${src.name}/examples/workspace";

  cargoPatches = [
    # https://github.com/NixOS/nixpkgs/issues/332957
    ./update-time-crate.patch
  ];

  cargoHash = "sha256-ull9BWzeKsnMi4wcH67FnKFzTjqEdiRlM3f+EKIPvvU=";

  nativeBuildInputs = [
    cargo-tauri.hook

    pkg-config
    wrapGAppsHook3
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      glib-networking
      libsoup
      webkitgtk
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

  # No one should be actually running this, so lets save some time
  buildType = "debug";
  doCheck = false;

  meta = {
    inherit (cargo-tauri.hook.meta) platforms;
  };
}
