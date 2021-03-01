{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "batik";
  version = "1.13";

  src = fetchurl {
    url = "mirror://apache/xmlgraphics/batik/binaries/batik-bin-${version}.tar.gz";
    sha256 = "16sq90nbs6psgm3xz30sbs6r5dnpd3qzsvr1xvnp4yipwjcmhmkw";
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
