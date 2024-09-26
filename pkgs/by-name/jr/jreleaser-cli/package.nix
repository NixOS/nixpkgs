{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:
stdenv.mkDerivation rec {
  pname = "jreleaser-cli";
  version = "1.14.0";

  src = fetchurl {
    url = "https://github.com/jreleaser/jreleaser/releases/download/v${version}/jreleaser-tool-provider-${version}.jar";
    hash = "sha256-LkkVxC3/0s468O84sgp7cNX53QRzdmUjCw+cgSWa5U0=";
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
