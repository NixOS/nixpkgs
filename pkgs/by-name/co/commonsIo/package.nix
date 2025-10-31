{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "2.20.0";
  pname = "commons-io";

  src = fetchurl {
    url = "mirror://apache/commons/io/binaries/${pname}-${version}-bin.tar.gz";
    sha256 = "sha256-+hNGq8TV4g8w9Q2df9kpYniBg1h8dOX6mF/1kk4VLcw=";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp *.jar $out/share/java/
  '';

  meta = {
    homepage = "https://commons.apache.org/proper/commons-io";
    description = "Library of utilities to assist with developing IO functionality";
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
