{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  nodejs,
  pnpm_9,
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
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "Kenya-DK";
    repo = "quantframe-react";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ls6c9xLmjjx0kSh1s+HkdClrcTOvsAemjzqNwMeOd9c=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"createUpdaterArtifacts": "v1Compatible"' '"createUpdaterArtifacts": false'
  '';

  patches = [
    ./0001-disable-telemetry.patch
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-3IHwwbl1aH3Pzh9xq2Jfev9hj6/LXZaVaIJOPbgsquE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UyfSmlr+5mWmlisNtjF6jZKx92kdQziG26mgeZtkySY=";

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    wrapGAppsHook3
    nodejs
    pnpm_9.configHook
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Warframe Market listings and transactions manager";
    mainProgram = "quantframe";
    homepage = "https://quantframe.app/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ nyukuru ];
  };
})
