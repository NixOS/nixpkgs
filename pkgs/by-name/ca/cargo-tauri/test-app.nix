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
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:
<<<<<<< HEAD
=======

let
  pnpm = pnpm_9;
in

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
stdenv.mkDerivation (finalAttrs: {
  pname = "test-app";
  inherit (cargo-tauri) version src;

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  inherit (cargo-tauri) cargoDeps;

<<<<<<< HEAD
  pnpmDeps = fetchPnpmDeps {
=======
  pnpmDeps = pnpm.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (finalAttrs)
      pname
      version
      src
      ;
<<<<<<< HEAD
    pnpm = pnpm_9;
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    fetcherVersion = 1;
    hash = "sha256-gHniZv847JFrmKnTUZcgyWhFl/ovJ5IfKbbM5I21tZc=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    pkg-config
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
=======
    pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
