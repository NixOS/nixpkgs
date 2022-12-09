{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "batik";
  version = "1.16";

  src = fetchurl {
    url = "mirror://apache/xmlgraphics/batik/binaries/batik-bin-${version}.tar.gz";
    sha256 = "sha256-Y4bJ6X46sKx1+fmNkOS2RU7gn7n0fKDnkOYMq0S8fYM=";
  };

  meta = with lib; {
    description = "Java based toolkit for handling SVG";
    homepage = "https://xmlgraphics.apache.org/batik";
    license = licenses.asl20;
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };

  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';
}
