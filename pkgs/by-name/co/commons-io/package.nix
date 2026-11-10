{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.22.0";
  pname = "commons-io";

  src = fetchurl {
    url = "mirror://apache/commons/io/binaries/commons-io-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-DQ17WESs+TMizYkp7yG103LZdS8i+XqEkfFrlttoTm8=";
  };

  installPhase = ''
    tar xf ${finalAttrs.src}
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
})
