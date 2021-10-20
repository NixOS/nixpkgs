{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "batik";
  version = "1.14";

  src = fetchurl {
    url = "mirror://apache/xmlgraphics/batik/binaries/batik-bin-${version}.tar.gz";
    sha256 = "sha256-D06qgb5wdS5AahnznDnAGISPCZY/CPqJdGQFRwUsRhg=";
  };

  meta = with lib; {
    description = "Java based toolkit for handling SVG";
    homepage = "https://xmlgraphics.apache.org/batik";
    license = licenses.asl20;
    platforms = platforms.unix;
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';
}
