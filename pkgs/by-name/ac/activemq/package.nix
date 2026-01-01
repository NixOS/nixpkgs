{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
<<<<<<< HEAD
  version = "6.2.0";
=======
  version = "6.1.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
stdenvNoCC.mkDerivation {
  pname = "activemq";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/activemq/${version}/apache-activemq-${version}-bin.tar.gz";
<<<<<<< HEAD
    hash = "sha256-J3u/p5LRQPgJvQKm4/1TgZVUuFetWlItcWoUpn9jxpg=";
=======
    hash = "sha256-BCrdMR698xAsl+8nY8DpwdZZH6LH2C5FBNZ2sRUmtBk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
