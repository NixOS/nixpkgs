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
, python3Packages
}:

stdenv.mkDerivation rec {
#python3.pkgs.buildPythonApplication rec {
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
    gobject-introspection
    gtk4
    wrapGAppsHook4
    (python3.withPackages (pp: [ pp.pygobject3 ]))
  ];

  propagatedBuildInputs = [ #with python3Packages; [
    #pycairo
    #pygobject3
    #lxml
    #gst-python
    #liblarch
    #caldav

    gtk4
    libadwaita
    gobject-introspection
    (python3.withPackages (pp: [ pp.pygobject3 ]))

  ];

  buildInputs = [
    gobject-introspection
    (python3.withPackages (pp: [ pp.pygobject3 ]))
  ];

  pythonPath = with python3Packages; [
    pygobject3
    click
  ];

  #strictDeps = true;

  #dontWrapGApps = true;

  #postFixup = ''
  #  makeWrapper ${python3.interpreter} $out/bin/flashcards \
  #    --add-flags "$out/share/flashcards/flashcards/main.py" \
  #    --prefix PYTHONPATH : "$PYTHONPATH" \
  #    ''${makeWrapperArgs[@]} \
  #    ''${gappsWrapperArgs[@]}
  #'';

  meta = with lib; {
    description = "Simple and clean flashcard memorizing app";
    homepage = "https://github.com/fkinoshita/FlashCards";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
