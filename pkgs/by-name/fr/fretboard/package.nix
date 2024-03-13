{ lib
, blueprint-compiler
, cargo
, desktop-file-utils
, fetchFromGitHub
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

stdenv.mkDerivation rec {
  pname = "fretboard";
  version = "5.4";

  src = fetchFromGitHub {
    owner = "bragefuglseth";
    repo = "fretboard";
    rev = "v${version}";
    hash = "sha256-GqnwAB7hmg2QLwSWqrZtTp6+FybK8/v4GZx/lMi0dGY=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-sGvb1+HKIqNSgCV9UzkCrkGrpjA34Pe9eq2/w3K/w/E=";
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
    description = "Look up guitar chords";
    homepage = "https://github.com/bragefuglseth/fretboard";
    changelog = "https://github.com/bragefuglseth/fretboard/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ michaelgrahamevans ];
    mainProgram = "fretboard";
    platforms = platforms.unix;
  };
}
