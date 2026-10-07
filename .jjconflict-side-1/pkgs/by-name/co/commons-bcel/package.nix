{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.12.0";
  pname = "commons-bcel";

  src = fetchurl {
    url = "mirror://apache/commons/bcel/binaries/bcel-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-6dg42j/EwgxIkd416H8P4Pf9abeQUyAjOO4UQCzWl70=";
  };

  installPhase = ''
    tar xf ${finalAttrs.src}
    mkdir -p $out/share/java
    cp bcel-${finalAttrs.version}.jar $out/share/java/
  '';

  meta = {
    homepage = "https://commons.apache.org/proper/commons-bcel/";
    description = "Gives users a convenient way to analyze, create, and manipulate (binary) Java class files";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = [ ];
    license = lib.licenses.asl20;
    platforms = with lib.platforms; unix;
  };
})
