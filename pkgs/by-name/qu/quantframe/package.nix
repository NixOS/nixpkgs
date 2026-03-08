{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  pkg-config,
  glib-networking,
  openssl,
  webkitgtk_4_1,
  wrapGAppsHook3,
  libsoup_3,
  libayatana-appindicator,
  gtk3,
  gst_all_1,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "quantframe";
  version = "1.6.12";

  src = fetchFromGitHub {
    owner = "Kenya-DK";
    repo = "quantframe-react";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IF+8filOXG+4nWpivyYknkT+hAg8nhG10Hfm79/m3Uc=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": "v1Compatible"' '"createUpdaterArtifacts": false'
  '';

  patches = [
    ./0001-disable-telemetry.patch
    ./0002-sync-node-packages.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-omomvnHUiEfGVJn6LApWOnRwSVO8kpMLN3Jz0MhwPpQ=";
  };

  cargoHash = "sha256-Ffy7dutFVQNZUFm9/iW0qPqUJ9bbRW6PeuC3eNNqfk8=";

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  buildInputs = [
    openssl
    libsoup_3
    glib-networking
    gtk3
    libayatana-appindicator
    webkitgtk_4_1
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Warframe Market listings and transactions manager";
    mainProgram = "quantframe";
    homepage = "https://quantframe.app/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nyukuru
      enkarterisi
    ];
  };
})
