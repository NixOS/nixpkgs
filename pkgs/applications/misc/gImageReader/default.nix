{ stdenv, fetchFromGitHub, cmake, pkgconfig, libuuid
, sane-backends, podofo, libjpeg, djvulibre, libxmlxx3, libzip, tesseract
, intltool, poppler, json-glib
, ninja
, python3

# Gtk deps
# upstream gImagereader supports Qt too
, gtk3, gobject-introspection, wrapGAppsHook
, gnome3, gtkspell3, gtkspellmm, cairomm
}:

let
  variant = "gtk";
  pythonEnv = python3.withPackages( ps: with ps;[ pygobject3 ] );
in
stdenv.mkDerivation rec {
  name = "gImageReader-${version}";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner= "manisandro";
    repo = "gImageReader";
    rev = "v${version}";
    sha256 = "0pjk4kr7bc5q4hi1xf7na2zln9fyqdazgzq62r3bg41nzy7fakcz";
  };

  nativeBuildInputs = [
    cmake ninja
    intltool
    pkgconfig
    pythonEnv

    # Gtk specific
    wrapGAppsHook
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
    gnome3.gtkmm
    gtkspell3
    gtkspellmm
    gnome3.gtksourceview
    gnome3.gtksourceviewmm
    cairomm
    json-glib
  ];

  # interface type can be where <type> is either gtk, qt5, qt4
  cmakeFlags = [ "-DINTERFACE_TYPE=${variant}" ];

  meta = with stdenv.lib; {
    description = "A simple Gtk/Qt front-end to tesseract-ocr";
    homepage = https://github.com/manisandro/gImageReader;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [teto];
    platforms = platforms.linux;
  };
}
