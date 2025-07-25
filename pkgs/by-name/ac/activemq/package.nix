{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "6.1.7";
in
stdenvNoCC.mkDerivation {
  pname = "activemq";
  inherit version;

  src = fetchurl {
    url = "mirror://apache/activemq/${version}/apache-activemq-${version}-bin.tar.gz";
    hash = "sha256-dcxBEJqJd0XUSsonNYVo88vgzVj8a7/wNag8Td9I0xY=";
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
