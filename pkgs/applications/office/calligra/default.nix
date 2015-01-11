{ stdenv, fetchurl, cmake, kdelibs, attica, perl, zlib, libpng, boost, mesa
, kdepimlibs, createresources ? null, eigen, qca2, exiv2, soprano, marble, lcms2
, fontconfig, freetype, sqlite, icu, libwpd, libwpg, pkgconfig, popplerQt4
, libkdcraw, libxslt, fftw, glew, gsl, shared_desktop_ontologies, okular
, libvisio, kactivities, mysql, postgresql, freetds, xbase, openexr, ilmbase
, libodfgen, opencolorio, openjpeg, pstoedit, librevenge
 }:

stdenv.mkDerivation rec {
  name = "calligra-2.8.6";

  src = fetchurl {
    url = "mirror://kde/stable/${name}/${name}.tar.xz";
    sha256 = "587dda4a340f46e28fe69de8f292fa33a3cf237445013f6ce5ceafa191cb3694";
  };

  nativeBuildInputs = [ cmake perl pkgconfig ];

# TODO: package Vc, libWPS, Spnav, m2mml, LibEtonyek, poppler-qt4-xpdf-headers
# not found: xbase, openjpeg(too new)

  buildInputs = [ kdelibs attica zlib libpng boost mesa kdepimlibs
    createresources eigen qca2 exiv2 soprano marble lcms2 fontconfig freetype
    sqlite icu libwpd libwpg popplerQt4 libkdcraw libxslt fftw glew gsl
    shared_desktop_ontologies okular libodfgen opencolorio openjpeg
    libvisio kactivities mysql postgresql freetds xbase openexr pstoedit
    librevenge
  ];

  patches = [ ./librevenge.patch ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  meta = {
    description = "A Qt/KDE office suite, formely known as koffice";
    homepage = http://calligra.org;
    maintainers = with stdenv.lib.maintainers; [ urkud phreedom ];
    inherit (kdelibs.meta) platforms;
  };
}
