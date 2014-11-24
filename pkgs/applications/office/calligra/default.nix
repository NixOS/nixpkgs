{ stdenv, fetchurl, cmake, kdelibs, attica, perl, zlib, libpng, boost, mesa
, kdepimlibs, createresources ? null, eigen, qca2, exiv2, soprano, marble, lcms2
, fontconfig, freetype, sqlite, icu, libwpd, libwpg, pkgconfig, popplerQt4
, libkdcraw, libxslt, fftw, glew, gsl, shared_desktop_ontologies, okular
, libvisio, kactivities, mysql, postgresql, freetds, xbase, openexr, ilmbase
 }:

stdenv.mkDerivation rec {
  name = "calligra-2.8.6";

  src = fetchurl {
    url = "mirror://kde/stable/${name}/${name}.tar.xz";
    sha256 = "587dda4a340f46e28fe69de8f292fa33a3cf237445013f6ce5ceafa191cb3694";
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
    description = "A Qt/KDE office suite, formely known as koffice";
    homepage = http://calligra.org;
    maintainers = with stdenv.lib.maintainers; [ urkud phreedom ];
    inherit (kdelibs.meta) platforms;
  };
}
