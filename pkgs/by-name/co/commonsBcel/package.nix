{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "6.11.0";
  pname = "commons-bcel";

  src = fetchurl {
    url = "mirror://apache/commons/bcel/binaries/bcel-${finalAttrs.version}-bin.tar.gz";
    hash = "sha256-tLR5d8D+w4Gd7qeGLx3Zy+oNQLH0bKYZOe7GZ3qJYs4=";
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
