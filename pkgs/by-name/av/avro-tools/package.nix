{
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  lib,
}:
let
  pname = "avro-tools";
  version = "1.12.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "mirror://maven/org/apache/avro/avro-tools/${version}/${pname}-${version}.jar";
    sha256 = "sha256-+OTQ2UWFLcL5HDv4j33LjKvADg/ClbuS6JPlSUXggIU=";
  };

  dontUnpack = true;

  buildInputs = [ jre ];
  nativeBuildInputs = [ makeWrapper ];
  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/libexec/avro-tools
    cp $src $out/libexec/avro-tools/${pname}.jar

    makeWrapper ${jre}/bin/java $out/bin/avro-tools \
    --add-flags "-jar $out/libexec/avro-tools/${pname}.jar"
  '';

  meta = {
    homepage = "https://avro.apache.org/";
    description = "Avro command-line tools and utilities";
    mainProgram = "avro-tools";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
