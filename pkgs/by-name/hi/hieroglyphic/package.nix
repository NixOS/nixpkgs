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
}:

let
  inherit (darwin.apple_sdk.frameworks) CoreFoundation Foundation;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hieroglyphic";
  version = "1.0.1";
  # Note: 1.1.0 requires a higher gtk4 version. This requirement could be patched out.

  src = fetchFromGitHub {
    owner = "FineFindus";
    repo = "Hieroglyphic";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Twx3yM71xn2FT3CbiFGbo2knGvb4MBl6VwjWlbjfks0=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    hash = "sha256-Se/YCi0e+Uoh5guDteLRXZYyk7et0NA8cv+vNpLxzx4=";
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
  ];

  buildInputs =
    [
      glib
      gtk4
      libadwaita
    ]
    ++ lib.optionals stdenv.isDarwin [
      CoreFoundation
      Foundation
    ];

  # needed for darwin
  env.GETTEXT_DIR = "${gettext}";

  meta = {
    changelog = "https://github.com/FineFindus/Hieroglyphic/releases/tag/v${finalAttrs.version}";
    description = "A tool based on detexify for finding LaTeX symbols from drawings";
    homepage = "https://apps.gnome.org/en/Hieroglyphic/";
    license = lib.licenses.gpl3Only;
    mainProgram = "hieroglyphic";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
