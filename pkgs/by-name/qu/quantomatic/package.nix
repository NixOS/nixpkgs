{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quantomatic";
  version = "0.7";

  src = fetchurl {
    url = "https://github.com/Quantomatic/quantomatic/releases/download/v${finalAttrs.version}/Quantomatic-v${finalAttrs.version}.jar";
    sha256 = "04dd5p73a7plb4l4x2balam8j7mxs8df06rjkalxycrr1id52q4r";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/libexec/quantomatic
    cp $src $out/libexec/quantomatic/quantomatic.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/quantomatic --add-flags "-jar $out/libexec/quantomatic/quantomatic.jar"
  '';

  meta = {
    description = "Piece of software for reasoning about monoidal theories; in particular, quantum information processing";
    mainProgram = "quantomatic";
    license = lib.licenses.gpl3;
    homepage = "https://quantomatic.github.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ nickhu ];
    platforms = lib.platforms.all;
  };
})
