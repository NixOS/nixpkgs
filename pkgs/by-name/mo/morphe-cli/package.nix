{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,

}:
let
  pname = "morphe-cli";
  version = "1.3.0";

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/MorpheApp/morphe-cli/releases/download/v${version}/morphe-cli-${version}-all.jar";
    hash = "sha256-BFlT/uNuJz5qTEzeOd70arhuQtkWqW6zp6axIV2A4Ps=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$prefix/bin"

    makeWrapper ${jre}/bin/java $out/bin/morphe-cli \
      --add-flags "-jar $src" \
      --prefix PATH : "$PATH"

    runHook postInstall
  '';

  meta = {
    description = "Command-line application that uses Morphe Patcher to patch Android apps";
    homepage = "https://github.com/MorpheApp/morphe-cli";
    license = lib.licenses.gpl3Only;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    maintainers = [ lib.maintainers.hetraeus ];
    mainProgram = "morphe-cli";
  };
}
