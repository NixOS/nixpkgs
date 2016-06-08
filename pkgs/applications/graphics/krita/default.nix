{ stdenv, fetchurl, cmake, kdelibs, attica, perl, zlib, libpng, boost, mesa
, kdepimlibs, createresources ? null, eigen, qca2, exiv2, soprano, marble, lcms2
, fontconfig, freetype, sqlite, icu, libwpd, libwpg, pkgconfig, poppler_qt4
, libkdcraw, libxslt, fftw, glew, gsl, shared_desktop_ontologies, okular
, libvisio, kactivities, mysql, postgresql, freetds, xbase, openexr, ilmbase
, libodfgen, opencolorio, openjpeg, pstoedit, librevenge, oxygen_icons
 }:

stdenv.mkDerivation rec {
  name = "krita-2.9.5";

  src = fetchurl {
    url = "mirror://kde/stable/calligra-2.9.6/calligra-2.9.6.tar.xz";
    sha256 = "1151k0x2s2k9p833l5hhgi8ph55k5b76dpw5a034abry2cvl2mkq";
  };

  nativeBuildInputs = [ cmake perl pkgconfig ];

# TODO: package Vc, libWPS, Spnav, m2mml, LibEtonyek, poppler-qt4-xpdf-headers
# not found: xbase, openjpeg(too new)

  buildInputs = [ kdelibs attica zlib libpng boost mesa kdepimlibs
    createresources eigen qca2 exiv2 soprano marble lcms2 fontconfig freetype
    sqlite icu libwpd libwpg poppler_qt4 libkdcraw libxslt fftw glew gsl
    shared_desktop_ontologies okular libodfgen opencolorio openjpeg
    libvisio kactivities mysql.lib postgresql freetds xbase openexr pstoedit
    librevenge oxygen_icons
  ];

  cmakeFlags = ''
    -DPRODUCTSET=KRITA
  '';

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  meta = {
    description = "A digital painting application";
    longDescription = ''
      Krita is the full-featured free digital painting studio for artists who
      want to create professional work from start to end. Krita is used by
      comic book artists, illustrators, concept artists, matte and texture
      painters and in the digital VFX industry.
    '';
    homepage = http://calligra.org;
    maintainers = with stdenv.lib.maintainers; [ urkud phreedom epitrochoid ];
    inherit (kdelibs.meta) platforms;
  };
}
