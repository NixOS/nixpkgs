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
  libuuid,
  libxmlxx3,
  libzip,
  ninja,
  podofo,
  poppler,
  python3,
  sane-backends,
  tesseract,
  withQt6 ? false ? false, kdePackages ? null, qt6Packages ? null, wrapQtAppsHook ? null,
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
    ++ lib.optionals withQt6 (
      with qt6Packages;
      [
        kdePackages.poppler
        qtbase
        qtspell
        quazip
      ]
    );

  # interface type can be where <type> is either gtk, qt5, qt4
  cmakeFlags =
    [ "-DINTERFACE_TYPE=gtk" ]
    ++ lib.optionals withQt6 [ "-DINTERFACE_TYPE=qt6 -DQT_VER=6" ];

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
