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

  meta = with lib; {
    description = "macOS file archiver";
    homepage = "https://www.keka.io";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.darwin;
  };
})
