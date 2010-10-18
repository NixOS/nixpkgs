{stdenv, fetchurl, kdelibs, x11, zlib, libpng, libjpeg, perl, qt3}:

stdenv.mkDerivation {
  name = "k3b-1.0.5";

  src = fetchurl {
    url = mirror://sourceforge/k3b/k3b-1.0.5.tar.bz2;
    sha256 = "1pshv8na1sr9xcmkr0byjgyl8jmxwcylkl8pwjvripja4fgpkyfl";
  };

  buildInputs = [kdelibs x11 zlib libpng libjpeg perl qt3];

  configureFlags = "--without-arts";

  meta = {
    description = "A CD and DVD authoring application for KDE";
    homepage = http://www.k3b.org/;
  };
}
