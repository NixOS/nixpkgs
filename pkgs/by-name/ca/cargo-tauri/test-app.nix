{
  lib,
  stdenv,
  rustPlatform,
  cargo-tauri,
  darwin,
  glib-networking,
  libayatana-appindicator,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "test-app";
  inherit (cargo-tauri) version src;

  cargoLock = {
    inherit (cargo-tauri.cargoDeps) lockFile;
    outputHashes = {
      "schemars_derive-0.8.21" = "sha256-AmxBKZXm2Eb+w8/hLQWTol5f22uP8UqaIh+LVLbS20g=";
    };
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  pnpmDeps = pnpm_9.fetchDeps {
    inherit
      pname
      version
      src
      ;

    hash = "sha256-bqFjnWCKnIbjSDdi+A2pvyquRso3BTL2YbkKJ4lHl10=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    pkg-config
    pnpm_9.configHook
    wrapGAppsHook4
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isLinux [
      glib-networking
      libayatana-appindicator
      webkitgtk_4_1
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.WebKit
    ];

  buildAndTestSubdir = "examples/api/src-tauri";

  # This example depends on the actual `api` package to be built in-tree
  preBuild = ''
    pnpm --filter '@tauri-apps/api' build
  '';

  # No one should be actually running this, so lets save some time
  buildType = "debug";
  doCheck = false;

  meta = {
    inherit (cargo-tauri.hook.meta) platforms;
  };
}
