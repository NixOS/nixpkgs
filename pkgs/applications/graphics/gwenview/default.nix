{stdenv, fetchurl, kdelibs, exiv2, libXt, libXext, zlib, libjpeg, perl, qt3, 
  libpng, expat }:

stdenv.mkDerivation {
  name = "gwenview-1.4.2";

  src = fetchurl {
    url = mirror://sourceforge/gwenview/gwenview-1.4.2.tar.bz2;
    sha256 = "26ec1a3f3ac7cce9584b44e6090402776fb84df3fc5f9e5aadbe66e9887851fd";
  };

  configurePhase = ''
    LDFLAGS="$LDFLAGS -ljpeg" ./configure --without-arts --prefix=$out
    '';

  buildInputs = [ kdelibs exiv2 libXt libXext zlib libjpeg perl qt3 libpng expat ];

  meta = {
    homepage = http://gwenview.sourceforge.net/;
    description = "KDE photo viewer";
    license = "GPLv2+";
  };
}
