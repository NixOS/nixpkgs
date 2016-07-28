{stdenv, fetchurl, xproto, motif, libX11, libXt, libXpm, bison, flex}:

stdenv.mkDerivation rec {
  name = "alliance-5.0-20120515";

  src = fetchurl {
    url = "http://www-asim.lip6.fr/pub/alliance/distribution/5.0/${name}.tar.gz";
    sha256 = "12vvhank896fn93xgb8q3qbv32r94zhnk1xvwsymywn1k5v4jwd9";
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
