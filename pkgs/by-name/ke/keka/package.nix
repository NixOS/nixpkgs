{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "keka";
  version = "1.4.6";

  src = fetchzip {
    url = "https://github.com/aonez/Keka/releases/download/v${finalAttrs.version}/Keka-${finalAttrs.version}.zip";
    hash = "sha256-IgPnXHVtAaSOsaAYvo0ELRqvXpF2qAnJ/1QZ+FHzqn4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin
    cp -r . $out/Applications/Keka.app
    makeWrapper $out/Applications/Keka.app/Contents/MacOS/Keka $out/bin/keka \
      --add-flags "--cli"

    runHook postInstall
  '';

  meta = {
    description = "macOS file archiver";
    homepage = "https://www.keka.io";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = lib.platforms.darwin;
  };
})
