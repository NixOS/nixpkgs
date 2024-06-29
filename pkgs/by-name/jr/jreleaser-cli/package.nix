{ lib, stdenv, fetchurl, makeWrapper, jre }:
stdenv.mkDerivation rec {
  pname = "jreleaser-cli";
  version = "1.11.0";

  src = fetchurl {
    url = "https://github.com/jreleaser/jreleaser/releases/download/v${version}/jreleaser-tool-provider-${version}.jar";
    sha256 = "sha256-VkINXKVBBBK6/PIRPMVKZGY9afE7mAsqrcFPh2Algqk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/java/ $out/bin/
    cp $src $out/share/java/${pname}.jar
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}.jar"
  '';

  meta = with lib; {
    homepage = "https://jreleaser.org/";
    description = "Release projects quickly and easily";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ i-al-istannen ];
    mainProgram = "jreleaser-cli";
  };
}
