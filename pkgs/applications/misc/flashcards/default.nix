{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, gtk4
, pkg-config
, cmake
, libadwaita
, blueprint-compiler
, python3
, desktop-file-utils
, gobject-introspection
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "flashcards";
  version = "unstable-2023-06-11";

  src = fetchFromGitHub {
    owner = "fkinoshita";
    repo = "FlashCards";
    rev = "31d2be1cd5ea96be5266aedf24f73e8ac8a42c35";
    hash = "sha256-aPnXazBWO+fjRbn1BzCO+kuYPT3y7SwPM97HK44Pm5Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    blueprint-compiler
    python3
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gtk4
    libadwaita
    gobject-introspection
  ];

  meta = with lib; {
    description = "Simple and clean flashcard memorizing app";
    homepage = "https://github.com/fkinoshita/FlashCards";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
