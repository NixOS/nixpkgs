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
  libjpeg,
  libsForQt5,
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
  withQt5 ? false,
  withQt6 ? false,
  wrapGAppsHook3,
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

      gobject-introspection
      wrapGAppsHook3
    ]
    ++ lib.optionals withQt5 [ libsForQt5.wrapQtAppsHook ]
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

      cairomm
      gtkmm3
      gtksourceview3
      gtksourceviewmm
      gtkspell3
      gtkspellmm
      json-glib
    ]
    ++ lib.optionals withQt5 (
      with libsForQt5;
      [
        libsForQt5.poppler
        qtbase
        libsForQt5.qtspell
        qttools
        quazip
      ]
    )
    ++ lib.optionals withQt6 (
      with qt6Packages;
      [
        qt6Packages.poppler
        qtbase
        qt6Packages.qtspell
        qttools
        quazip
      ]
    );

  # interface type can be where <type> is either gtk, qt5, qt4
  cmakeFlags =
    [ "-DINTERFACE_TYPE=gtk" ]
    ++ lib.optionals withQt5 [ "-DINTERFACE_TYPE=qt5 -DQT_VER=5" ]
    ++ lib.optionals withQt6 [ "-DINTERFACE_TYPE=qt6 -DQT_VER=6" ];

  meta = with lib; {
    description = "Simple Gtk/Qt front-end to tesseract-ocr";
    mainProgram = if (withQt5 || withQt6) then "gimagereader-qt" else "gimagereader-gtk";
    homepage = "https://github.com/manisandro/gImageReader";
    changelog = "https://github.com/manisandro/gImageReader/blob/${version}/NEWS";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ teto ];
    platforms = platforms.linux;
  };
}
