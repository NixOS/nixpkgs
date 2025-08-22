{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  jre,
}:
stdenv.mkDerivation rec {
  pname = "jive";
  version = "7.45";

  src = fetchurl {
    url = "https://repo.maven.apache.org/maven2/org/tango-controls/Jive/${version}/Jive-${version}-jar-with-dependencies.jar";
    hash = "sha256-a/I4jMlTVYWN9zNBQnWbvT2MBHItexnwPly1XyOeR8U=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java
    cp $src $out/share/java/jive.jar
    makeWrapper ${jre}/bin/java $out/bin/jive \
      --add-flags "-classpath $out/share/java/jive.jar jive3.MainPanel"

    runHook postInstall
  '';

  meta = {
    description = "Standalone JAVA application designed to browse and edit the static TANGO database";
    homepage = "https://gitlab.com/tango-controls/jive";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.gilice ];
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
