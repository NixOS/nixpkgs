{ stdenv, fetchurl, cmake, kdelibs, attica, perl, zlib, libpng, boost, mesa
, kdepimlibs, createresources ? null, eigen, qca2, exiv2, soprano, marble, lcms2
, fontconfig, freetype, sqlite, icu, libwpd, libwpg, pkgconfig, popplerQt4
, libkdcraw, libxslt, fftw, glew, gsl, shared_desktop_ontologies }:

stdenv.mkDerivation rec {
  name = "calligra-2.3.92";

  src = fetchurl {
    url = "mirror://kde/unstable/${name}/${name}.tar.bz2";
    sha256 = "1ad7vzdhfkv48xhs9p84mwpq8zsdiajz3qjng3h2rswd88sgrblg";
  };

  buildNativeInputs = [ cmake perl pkgconfig ];

  buildInputs = [ kdelibs attica zlib libpng boost mesa kdepimlibs
    createresources eigen qca2 exiv2 soprano marble lcms2 fontconfig freetype
    sqlite icu libwpd libwpg popplerQt4 libkdcraw libxslt fftw glew gsl
    shared_desktop_ontologies ];

  meta = {
    description = "A Qt/KDE office suite, formely known as koffice";
    homepage = http://calligra.org;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
