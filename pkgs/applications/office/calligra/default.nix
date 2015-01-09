{ stdenv, fetchurl, cmake, kdelibs, attica, perl, zlib, libpng, boost, mesa
, kdepimlibs, createresources ? null, eigen, qca2, exiv2, soprano, marble, lcms2
, fontconfig, freetype, sqlite, icu, libwpd, libwpg, pkgconfig, popplerQt4
, libkdcraw, libxslt, fftw, glew, gsl, shared_desktop_ontologies, okular
, libvisio, kactivities, mysql, postgresql, freetds, xbase, openexr, ilmbase
 }:

stdenv.mkDerivation rec {
  name = "calligra-2.8.7";

  src = fetchurl {
    url = "mirror://kde/stable/${name}/${name}.tar.xz";
    sha256 = "1d8fx0xn8n8y6jglw8hhpk7kr6kbhsbaxqwqlfzmnzh7x9s8nsxg";
  };

  nativeBuildInputs = [ cmake perl pkgconfig ];

#  patches = [ ./fix-kde4.10-build.patch ];

# TODO: package Vc, libWPS, OCIO, OpenShiva, QtShiva, Spnav, m2mml
# TODO: not found popplerQt4

  buildInputs = [ kdelibs attica zlib libpng boost mesa kdepimlibs
    createresources eigen qca2 exiv2 soprano marble lcms2 fontconfig freetype
    sqlite icu libwpd libwpg popplerQt4 libkdcraw libxslt fftw glew gsl
    shared_desktop_ontologies okular 
    libvisio kactivities mysql postgresql freetds xbase openexr
];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  meta = {
    description = "Calligra Suite is a set of applications written to help you to accomplish your work. Calligra includes efficient and capable office components: Words for text processing,  Sheets for computations, Stage for presentations, Plan for planning, Flow for flowcharts, Kexi for database creation, Krita for painting and raster drawing, and Karbon for vector graphics.";
    homepage = http://calligra.org;
    maintainers = with stdenv.lib.maintainers; [ urkud phreedom ];
    inherit (kdelibs.meta) platforms;
  };
}
