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
  version = "5.3";

  src = fetchFromGitHub {
    owner = "bragefuglseth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wwq4Xq6IVLF2hICk9HfCpfxpWer8PNWywD8p3wQdp6U=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-H/dAKaYHxRmldny8EoasrcDROZhLo5UbHPAoMicDehA=";
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
    platforms = platforms.linux;
  };
}
