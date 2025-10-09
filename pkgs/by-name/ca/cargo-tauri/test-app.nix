{
  lib,
  stdenv,
  cargo-tauri,
  glib-networking,
  libayatana-appindicator,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

let
  pnpm = pnpm_9;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "test-app";
  inherit (cargo-tauri) version src;

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  inherit (cargo-tauri) cargoDeps;

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;

    fetcherVersion = 1;
    hash = "sha256-7F2vk6WUeXunTuXX9J0rVhl2I0ENYagRdqTy+WAXBB8=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    pkg-config
    pnpm.configHook
    rustPlatform.cargoCheckHook
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libayatana-appindicator
    webkitgtk_4_1
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
})
