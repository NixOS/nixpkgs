{
  lib,
  stdenv,
  fetchurl,
  unzip,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sloth-app";
  version = "3.4";

  src = fetchurl {
    url = "https://github.com/sveinbjornt/Sloth/releases/download/${finalAttrs.version}/sloth-${finalAttrs.version}.zip";
    hash = "sha256-K8DweBFAILEQyqri6NO+p5qRam+BHjIk1tl43gcseNs=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    unzip -d $out/Applications $src
    makeWrapper $out/Applications/Sloth.app/Contents/MacOS/Sloth $out/bin/Sloth

    runHook postInstall
  '';

  meta = {
    description = "Mac app that shows all open files, directories, sockets, pipes and devices";
    homepage = "https://sveinbjorn.org/sloth";
    license = lib.licenses.bsd3;
    mainProgram = "Sloth";
    maintainers = with lib.maintainers; [
      emilytrau
      iedame
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
