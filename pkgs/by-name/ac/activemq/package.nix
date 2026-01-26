{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "6.2.0";
in
stdenvNoCC.mkDerivation {
  pname = "activemq";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/activemq/${version}/apache-activemq-${version}-bin.tar.gz";
    hash = "sha256-J3u/p5LRQPgJvQKm4/1TgZVUuFetWlItcWoUpn9jxpg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv * $out/
    for j in $(find $out/lib -name "*.jar"); do
      cp="''${cp:+"$cp:"}$j";
    done
    echo "CLASSPATH=$cp" > $out/lib/classpath.env

    runHook postInstall
  '';

  meta = {
    homepage = "https://activemq.apache.org/";
    description = "Messaging and Integration Patterns server written in Java";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    mainProgram = "activemq";
    maintainers = [ lib.maintainers.anthonyroussel ];
    platforms = lib.platforms.unix;
  };
}
