{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  version = "6.10.0";
  pname = "commons-bcel";

  src = fetchurl {
    url = "mirror://apache/commons/bcel/binaries/bcel-${version}-bin.tar.gz";
    hash = "sha256-RRVXxPtwbT9AX92T60uDJpFWF6DiotcG1KvKrlFfEWU=";
  };

  installPhase = ''
    tar xf ${src}
    mkdir -p $out/share/java
    cp bcel-${version}.jar $out/share/java/
  '';

  meta = {
    homepage = "https://commons.apache.org/proper/commons-bcel/";
    description = "Gives users a convenient way to analyze, create, and manipulate (binary) Java class files";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = [ ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
}
