{stdenv, fetchurl, xproto, motif, libX11, libXt, libXpm, bison, flex}:

stdenv.mkDerivation {
  name = "alliance-5.0-20070718";

  src = fetchurl {
    url = http://www-asim.lip6.fr/pub/alliance/distribution/5.0/alliance-5.0-20070718.tar.gz;
    sha256 = "4e17c8f9f4d344061166856d47e58527c6ae870fda0c73b5ba0200967d23af9f";
  };

  buildInputs = [ xproto motif xproto libX11 libXt libXpm bison flex];

  patchPhase = ''
    sed -i -e \
      "s/private: static void  operator delete/public: static void  operator delete/" \
      nero/src/ADefs.h
  '';

  meta = {
      description = "Complete set of free CAD tools and portable libraries for VLSI design";
      homepage = http://www-asim.lip6.fr/recherche/alliance/;
  };
}
