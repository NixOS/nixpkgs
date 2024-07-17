{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "quantomatic";
  version = "0.7";

  src = fetchurl {
    url = "https://github.com/Quantomatic/quantomatic/releases/download/v${version}/Quantomatic-v${version}.jar";
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

  meta = with lib; {
    description = "A piece of software for reasoning about monoidal theories; in particular, quantum information processing";
    mainProgram = "quantomatic";
    license = licenses.gpl3;
    homepage = "https://quantomatic.github.io/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ nickhu ];
    platforms = platforms.all;
  };
}
