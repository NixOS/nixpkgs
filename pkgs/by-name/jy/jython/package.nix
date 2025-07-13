{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation rec {
  pname = "jython";

  version = "2.7.4";

  src = fetchurl {
    url = "https://search.maven.org/remotecontent?filepath=org/python/jython-standalone/${version}/jython-standalone-${version}.jar";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -pv $out/bin
    cp $src $out/jython.jar
    makeWrapper ${jre}/bin/java $out/bin/jython --add-flags "-jar $out/jython.jar"
  '';

  meta = {
    description = "Python interpreter written in Java";
    mainProgram = "jython";
    homepage = "https://jython.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.psfl;
    platforms = jre.meta.platforms;
  };
}
