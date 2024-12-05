{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libuuid
, sane-backends, podofo, libjpeg, djvulibre, libxmlxx3, libzip, tesseract
, intltool, poppler, json-glib
, ninja
, python3
, doxygen
, enchant

# Gtk deps
# upstream gImagereader supports Qt too
, gobject-introspection, wrapGAppsHook3
, gtkmm3, gtksourceview3, gtksourceviewmm, gtkspell3, gtkspellmm, cairomm
, kdePackages
, qt6Packages
, withGTK3 ? false
, withQt6 ? false ? false, wrapQtAppsHook ? null
}:

let
  pythonEnv = python3.withPackages (ps: with ps;[ pygobject3 ]);
in
stdenv.mkDerivation rec {
  pname = "gImageReader";
  version = "b794fd5a58dbefbc46158f32e706a61b3ba3c518";

  src = fetchFromGitHub {
    owner= "manisandro";
    repo = "gImageReader";
    rev = "${version}";
    sha256 = "sha256-6FU/49CmRDP91VoFzEsrJMgCKFlfsTKZcEYSfdeq2VU=";
  };

  nativeBuildInputs = [
    cmake ninja
    intltool
    pkg-config
    pythonEnv
    enchant
  ]
    ++ lib.optionals withGTK3 [
      gobject-introspection
      wrapGAppsHook3
    ]
    ++ lib.optionals withQt6 [ qt6Packages.wrapQtAppsHook ];

  buildInputs = [
    libxmlxx3
    libzip
    libuuid
    sane-backends
    podofo
    libjpeg
    djvulibre
    tesseract
    poppler
    doxygen
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
    maintainers = with maintainers; [teto];
    platforms = platforms.linux;
  };
}
