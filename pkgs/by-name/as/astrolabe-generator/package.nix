{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "astrolabe-generator";
  version = "3.3";

  src = fetchurl {
    url = "https://github.com/wymarc/astrolabe-generator/releases/download/v${version}/AstrolabeGenerator-${version}.zip";
    sha256 = "141gfmrqa1mf2qas87qig4phym9fg9gbrcfl2idzd5gi91824dn9";
  };

  buildInputs = [ jre ];
  nativeBuildInputs = [
    makeWrapper
    unzip
  ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/{bin,share/java}
    cp AstrolabeGenerator-${version}.jar $out/share/java

    makeWrapper ${jre}/bin/java $out/bin/AstrolabeGenerator \
      --add-flags "-jar $out/share/java/AstrolabeGenerator-${version}.jar"
  '';

  meta = with lib; {
    homepage = "https://www.astrolabeproject.com";
    description = "Java-based tool for generating EPS files for constructing astrolabes and related tools";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.gpl3;
    maintainers = [ ];
    mainProgram = "AstrolabeGenerator";
    platforms = platforms.all;
  };
}
