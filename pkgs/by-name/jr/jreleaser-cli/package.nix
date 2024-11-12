{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:
stdenv.mkDerivation rec {
  pname = "jreleaser-cli";
  version = "1.15.0";

  src = fetchurl {
    url = "https://github.com/jreleaser/jreleaser/releases/download/v${version}/jreleaser-tool-provider-${version}.jar";
    hash = "sha256-/FDoAYf+Uy+VcWT9KpW1IEqOCvCOOyV+8/cugpeUR7Y=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/java/ $out/bin/
    cp $src $out/share/java/${pname}.jar
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}.jar"
  '';

  meta = {
    homepage = "https://jreleaser.org/";
    description = "Release projects quickly and easily";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.i-al-istannen ];
    mainProgram = "jreleaser-cli";
  };
}
