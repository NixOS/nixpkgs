{ lib
, blueprint-compiler
, cargo
, desktop-file-utils
, fetchFromGitLab
, glib
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, rustPlatform
, rustc
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "switcheroo";
  version = "2.0.1";

  src = fetchFromGitLab {
    owner = "adhami3310";
    repo = "Switcheroo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3JlI0Co3yuD6fKaKlmz1Vg0epXABO+7cRvm6/PgbGUE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = finalAttrs.src;
    name = "switcheroo-${finalAttrs.version}";
    hash = "sha256-wC57VTJGiN2hDL2Z9fFw5H9c3Txqh30AHfR9o2DbcSk=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
  ];

  meta = with lib; {
    changelog = "https://gitlab.com/adhami3310/Switcheroo/-/releases/v${finalAttrs.version}";
    description = "An app for converting images between different formats";
    homepage = "https://gitlab.com/adhami3310/Switcheroo";
    license = licenses.gpl3Plus;
    mainProgram = "switcheroo";
    maintainers = with maintainers; [ michaelgrahamevans ];
    platforms = platforms.linux;
  };
})
