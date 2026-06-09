{
  rustPlatform,
  fetchFromForgejo,
  fetchNpmDeps,
  cargo-tauri,
  nodejs,
  npmHooks,
  pkg-config,
  lib,
  stdenv,
  wrapGAppsHook4,
  dbus,
  glib-networking,
  gtk3,
  webkitgtk_4_1,
  alsa-lib,
  libappindicator,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cyberia";
  version = "0.2.7";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "git.gay";
    owner = "zutyosh";
    repo = "Cyberia";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IngzQdGT3lHTJKsDJ+Rb+rejYwJ0QBdnTYCcBEPNDKY=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-LM/bqklNHIIFdhSYT4ndtB9j3uX7XYWL5fHZTxyeJ84=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-m/hJ7IwVTpWFtQ9TL76Dc34Gtm6Pt0+jOtR/yRF0jIs=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook

    nodejs
    npmHooks.npmConfigHook

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = [
    dbus
    gtk3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
    alsa-lib
    libappindicator
  ];

  meta = {
    description = "VRCX style client for Resonite";
    homepage = "https://git.gay/zutyosh/Cyberia";
    changelog = "https://git.gay/zutyosh/Cyberia/releases/tag/v${finalAttrs.version}";
    mainProgram = "cyberia";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ toasteruwu ];
  };
})
