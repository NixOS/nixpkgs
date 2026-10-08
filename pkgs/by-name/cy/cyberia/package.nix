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
  version = "0.2.8";

  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "git.gay";
    owner = "zutyosh";
    repo = "Cyberia";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MKq3Q0g02JiTnwyjUNv1CzCCmG43ZFCffRa7BmUU5SU=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-ghdZyJt/hE+r/D+FqyLrUNSvVDZf+FRv463K33XrNbs=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-aZsQHb1Hj7dmz/04E6KJ5AMKKTcN+4fSK8phwDg2YAU=";
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
