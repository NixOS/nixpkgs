{stdenv, fetchurl, libX11, libXt, libXext, libXrender, libXft,
 arts, qt, kdelibs, zlib, libpng, libjpeg, perl, expat}:

stdenv.mkDerivation {
  name = "konversation-1.1";
  src = fetchurl {
    url = http://download.berlios.de/konversation/konversation-1.1.tar.bz2;
    sha256 = "3ef15e7a46c10a11aa369ff80dd33b3e2feb54834dfc036d3609c1ed94476d33";
  };
  buildInputs = [ arts qt kdelibs libX11 libXt libXext libXrender libXft
                  zlib libpng libjpeg perl expat ];

  meta = {
    description = "An IRC client for KDE";
    homepage = http://konversation.kde.org/;
    license = "GPLv2";
  };
}
