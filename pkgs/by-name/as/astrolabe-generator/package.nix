{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astrolabe-generator";
  version = "3.3";

  src = fetchurl {
    url = "https://github.com/wymarc/astrolabe-generator/releases/download/v${finalAttrs.version}/AstrolabeGenerator-${finalAttrs.version}.zip";
    hash = "sha256-yTYiUEjxlfZbFNSxvF56LlUPL3kRH6QVFq4GhXN1L5A=";
  };

  buildInputs = [ jre ];
  nativeBuildInputs = [
    makeWrapper
    unzip
  ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/{bin,share/java}
    cp AstrolabeGenerator-${finalAttrs.version}.jar $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/AstrolabeGenerator \
      --add-flags "-jar $out/share/java/AstrolabeGenerator-${finalAttrs.version}.jar"
  '';

  meta = {
    homepage = "https://www.astrolabeproject.com";
    description = "Java-based tool for generating EPS files for constructing astrolabes and related tools";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "AstrolabeGenerator";
    platforms = lib.platforms.all;
  };
})
