{stdenv, fetchurl, kdelibs, exiv2, libXt, libXext, zlib, libjpeg, perl, qt3, 
  libpng, expat, cmake }:

stdenv.mkDerivation {
  name = "digikam-1.0.0";

  src = fetchurl {
    url = mirror://sourceforge/digikam/digikam-1.0.0.tar.bz2;
    sha256 = "0qblqyjn0vas8hyqn5s9rr401d93cagk53y3j8kch0mr0bk706bk";
  };

/*
  configurePhase = ''
    LDFLAGS="$LDFLAGS -ljpeg" ./configure --without-arts --prefix=$out
    '';
*/

  buildInputs = [ kdelibs exiv2 libXt libXext zlib libjpeg perl qt3 libpng expat cmake ];

  meta = {
    homepage = http://digikam.sourceforge.net/;
    description = "KDE 3.x photo viewer";
    # license = "GPLv2+";
  };
}
