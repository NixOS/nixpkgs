{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cairomm,
  djvulibre,
  doxygen,
  enchant,
  gobject-introspection,
  gtkmm3,
  gtksourceview3,
  gtksourceviewmm,
  gtkspell3,
  gtkspellmm,
  intltool,
  json-glib,
  kdePackages,
  libjpeg,
  libuuid,
  libxmlxx3,
  libzip,
  ninja,
  podofo,
  poppler,
  python3,
  qt6Packages,
  sane-backends,
  tesseract,
  wrapGAppsHook3,
  withGTK3 ? false,
  withQt6 ? false ? false, wrapQtAppsHook ? null,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [ pygobject3 ]);
in
stdenv.mkDerivation rec {
  pname = "gImageReader";
  version = "b794fd5a58dbefbc46158f32e706a61b3ba3c518";

  src = fetchFromGitHub {
    owner = "manisandro";
    repo = "gImageReader";
    rev = "${version}";
    sha256 = "sha256-6FU/49CmRDP91VoFzEsrJMgCKFlfsTKZcEYSfdeq2VU=";
  };

  nativeBuildInputs =
    [
      cmake
      pkg-config
      enchant
      intltool
      ninja
      pythonEnv
    ]
    ++ lib.optionals withGTK3 [
      gobject-introspection
      wrapGAppsHook3
    ]
    ++ lib.optionals withQt6 [ qt6Packages.wrapQtAppsHook ];

  buildInputs =
    [
      djvulibre
      doxygen
      libjpeg
      libuuid
      libxmlxx3
      libzip
      podofo
      poppler
      sane-backends
      tesseract
    ]
    ++ lib.optionals withGTK3 [
      cairomm
      gtkmm3
      gtksourceview3
      gtksourceviewmm
      gtkspell3
      gtkspellmm
      json-glib
    ]
    ++ lib.optionals withQt6 (
      with qt6Packages;
      [
        kdePackages.poppler
        qtbase
        qtspell
        qttools
        quazip
      ]
    );

  # interface type can be where <type> is either gtk, qt5, qt4
  cmakeFlags =
    [ ]
    ++ lib.optionals withQt6 [ "-DINTERFACE_TYPE=qt6 -DQT_VER=6" ]
    ++ lib.optionals withGTK3 [ "-DINTERFACE_TYPE=gtk" ];

  meta = with lib; {
    description = "Simple Gtk/Qt front-end to tesseract-ocr";
    mainProgram = if withQt6 then "gimagereader-qt6" else "gimagereader-gtk";
    homepage = "https://github.com/manisandro/gImageReader";
    changelog = "https://github.com/manisandro/gImageReader/blob/${version}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ teto ];
    platforms = platforms.linux;
  };
}
