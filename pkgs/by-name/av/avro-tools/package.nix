{
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "avro-tools";
  version = "1.12.0";

  src = fetchurl {
    url = "mirror://maven/org/apache/avro/avro-tools/${finalAttrs.version}/avro-tools-${finalAttrs.version}.jar";
    sha256 = "sha256-+OTQ2UWFLcL5HDv4j33LjKvADg/ClbuS6JPlSUXggIU=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/avro-tools
    cp $src $out/libexec/avro-tools/avro-tools.jar

    makeWrapper ${jre}/bin/java $out/bin/avro-tools \
    --add-flags "-jar $out/libexec/avro-tools/avro-tools.jar"
  '';

  meta = {
    homepage = "https://avro.apache.org/";
    description = "Avro command-line tools and utilities";
    mainProgram = "avro-tools";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ momeemt ];
  };
})
