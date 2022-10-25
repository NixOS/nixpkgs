{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "batik";
  version = "1.15";

  src = fetchurl {
    url = "mirror://apache/xmlgraphics/batik/binaries/batik-bin-${version}.tar.gz";
    sha256 = "sha256-NYo7+8DikUmDsioM1Q1YW1s3KwsQeTnwIKDr+RHxxyo=";
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
