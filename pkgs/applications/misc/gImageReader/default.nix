{ stdenv, fetchFromGitHub, cmake, pkgconfig, libuuid
, sane-backends, podofo, libjpeg, djvulibre, libxmlxx3, libzip, tesseract
, intltool, poppler, json-glib
, ninja
, python3

# Gtk deps
# upstream gImagereader supports Qt too
, gobject-introspection, wrapGAppsHook
, gtkmm3, gtksourceview3, gtksourceviewmm, gtkspell3, gtkspellmm, cairomm
}:

let
  variant = "gtk";
  pythonEnv = python3.withPackages( ps: with ps;[ pygobject3 ] );
in
stdenv.mkDerivation rec {
  pname = "gImageReader";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner= "manisandro";
    repo = "gImageReader";
    rev = "v${version}";
    sha256 = "17hz2dgxx2j7hsk0lx3riidqvlsg0ylnicjd2gphsi3yp7w20zdj";
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

  meta = with stdenv.lib; {
    description = "A simple Gtk/Qt front-end to tesseract-ocr";
    homepage = "https://github.com/manisandro/gImageReader";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [teto];
    platforms = platforms.linux;
  };
}
