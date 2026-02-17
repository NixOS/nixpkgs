{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "revanced-cli";
  version = "5.0.1";

  src = fetchurl {
    url = "https://github.com/revanced/revanced-cli/releases/download/v${finalAttrs.version}/revanced-cli-${finalAttrs.version}-all.jar";
    hash = "sha256-tq+DSWAPVupR2W1Jqk0vKI4ox5zWSTSbpwyLcs4EXa8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$prefix/bin"

    makeWrapper ${jre}/bin/java $out/bin/revanced-cli \
      --add-flags "-jar $src" \
      --prefix PATH : "$PATH"

    runHook postInstall
  '';

  meta = {
    description = "Command line application as an alternative to the ReVanced Manager";
    homepage = "https://github.com/revanced/revanced-cli";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
    mainProgram = "revanced-cli";
  };
})
