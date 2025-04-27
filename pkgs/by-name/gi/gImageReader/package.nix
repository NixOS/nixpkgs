{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libuuid,
  sane-backends,
  podofo,
  libjpeg,
  djvulibre,
  libxmlxx3,
  libzip,
  tesseract,
  intltool,
  poppler,
  json-glib,
  ninja,
  python3,

  # Gtk deps
  # upstream gImagereader supports Qt too
  gobject-introspection,
  wrapGAppsHook3,
  gtkmm3,
  gtksourceview3,
  gtksourceviewmm,
  gtkspell3,
  gtkspellmm,
  cairomm,
}:

let
  variant = "gtk";
  pythonEnv = python3.withPackages (ps: with ps; [ pygobject3 ]);
in
stdenv.mkDerivation rec {
  pname = "gImageReader";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "manisandro";
    repo = "gImageReader";
    rev = "v${version}";
    sha256 = "sha256-yBkVeufRRoSAc20/8mV39widBPloHFz12K7B4Y9xiWg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    intltool
    pkg-config
    pythonEnv

    # Gtk specific
    wrapGAppsHook3
    gobject-introspection
  ];

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

    # Gtk specific
    gtkmm3
    gtkspell3
    gtkspellmm
    gtksourceview3
    gtksourceviewmm
    cairomm
    json-glib
  ];

  # interface type can be where <type> is either gtk, qt5, qt4
  cmakeFlags = [ "-DINTERFACE_TYPE=${variant}" ];

  meta = with lib; {
    description = "Simple Gtk/Qt front-end to tesseract-ocr";
    mainProgram = "gimagereader-gtk";
    homepage = "https://github.com/manisandro/gImageReader";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ teto ];
    platforms = platforms.linux;
  };
}
