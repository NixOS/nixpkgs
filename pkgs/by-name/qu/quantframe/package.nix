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
  version = "1.6.28";

  src = fetchFromGitHub {
    owner = "Kenya-DK";
    repo = "quantframe-react";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TbkdfIPn/i+ocgJ0r7i6CJi+rr9eE8QK1798piuSJio=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  patches = [
    ./0001-disable-telemetry.patch
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
    hash = "sha256-TAghp3rBySgNpzZ8ruG9jBO0BLcR3QhWK2XJ9C7VcuA=";
  };

  cargoHash = "sha256-UH1JP2HBQ5RetdJRpWlIXU7Oui+Zm4uTxQqMDVAlFo4=";

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
    mainProgram = "Quantframe";
    homepage = "https://quantframe.app/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      nyukuru
      enkarterisi
    ];
  };
})
