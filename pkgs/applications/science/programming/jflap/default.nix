{ lib, stdenv, fetchurl, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "jflap";
  version = "7.1";

  src = fetchurl {
    url = "https://www.jflap.org/jflaptmp/july27-18/JFLAP7.1.jar";
    sha256 = "oiwJXdxWsYFj6Ovu7xZbOgTLVw8160a5YQUWbgbJlAY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/java
    cp -s $src $out/share/java/jflap.jar
    makeWrapper ${jre}/bin/java $out/bin/jflap --add-flags "-jar $out/share/java/jflap.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "GUI tool for experimenting with formal languages topics";
    homepage = "https://www.jflap.org/";
    license = licenses.unfree;
    maintainers = [ maintainers.grnnja ];
    platforms = platforms.all;
  };
}
