{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  nodejs,
  pnpm_9,
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
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "quantframe";
  version = "1.6.14";

  src = fetchFromGitHub {
    owner = "Kenya-DK";
    repo = "quantframe-react";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zRJYlf9eucNcTcVn5D3lt7vYLpzFXmwJy2Srow8eLdk=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": true' '"createUpdaterArtifacts": false'
  '';

  patches = [ ./0001-disable-telemetry.patch ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-LlOL+hTWS+9DHEmaSmYnnPlvB/Ya30lOh9y/+MzfvyA=";
  };

  cargoHash = "sha256-Bet6ve5OiQiMxiovvUbGSWTH1bnB+6Dsqbr1z2Pk+Kw=";

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
    nodejs
    pnpmConfigHook
    pnpm_9
  ];

  buildInputs = [
    openssl
    libsoup_3
    glib-networking
    gtk3
    libayatana-appindicator
    webkitgtk_4_1
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  # Upstream ships mismatched NPM/Rust Tauri package versions (e.g., tauri v2.6.2 vs @tauri-apps/api v2.0.0)
  tauriBuildFlags = [ "--ignore-version-mismatches" ];

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
