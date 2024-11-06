{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  desktop-file-utils,
  glib,
  gtk4,
  libadwaita,
  darwin,
  gettext,
  appstream,
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Foundation;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hieroglyphic";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = "Hieroglyphic";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-8UUFatJwtxqumhHd0aiPk6nKsaaF/jIIqMFxXye0X8U=";
  };

  # We have to use importCargoLock here because `cargo vendor` currently doesn't support workspace
  # inheritance within Git dependencies, but importCargoLock does.
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "detexify-0.4.0" = "sha256-BPOHNr3pwu2il3/ERko+WHAWby4rPR49i62tXDlDRu0=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream
  ];

  buildInputs =
    [
      glib
      gtk4
      libadwaita
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreFoundation
      Foundation
    ];

  # needed for darwin
  env.GETTEXT_DIR = "${gettext}";

  meta = {
    changelog = "https://github.com/FineFindus/Hieroglyphic/releases/tag/v${finalAttrs.version}";
    description = "Tool based on detexify for finding LaTeX symbols from drawings";
    homepage = "https://apps.gnome.org/en/Hieroglyphic/";
    license = lib.licenses.gpl3Only;
    mainProgram = "hieroglyphic";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
