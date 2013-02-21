{ stdenv, fetchurl, cmake, kdelibs, attica, perl, zlib, libpng, boost, mesa
, kdepimlibs, createresources ? null, eigen, qca2, exiv2, soprano, marble, lcms2
, fontconfig, freetype, sqlite, icu, libwpd, libwpg, pkgconfig, popplerQt4
, libkdcraw, libxslt, fftw, glew, gsl, shared_desktop_ontologies, okular }:

stdenv.mkDerivation rec {
  name = "calligra-2.5.0";

  src = fetchurl {
    url = "mirror://kde/stable/${name}/${name}.tar.bz2";
    sha256 = "0q6ydi7hzrzwqzb38gikdh1l2zf8qp4i3nkgyb01148bjwrhvf21";
  };

  nativeBuildInputs = [ cmake perl pkgconfig ];

  buildInputs = [ kdelibs attica zlib libpng boost mesa kdepimlibs
    createresources eigen qca2 exiv2 soprano marble lcms2 fontconfig freetype
    sqlite icu libwpd libwpg popplerQt4 libkdcraw libxslt fftw glew gsl
    shared_desktop_ontologies okular ];

  meta = {
    description = "A Qt/KDE office suite, formely known as koffice";
    homepage = http://calligra.org;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
