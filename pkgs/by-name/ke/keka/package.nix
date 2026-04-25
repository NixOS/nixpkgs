{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "keka";
  version = "1.6.3";

  src = fetchzip {
    url = "https://github.com/aonez/Keka/releases/download/v${finalAttrs.version}/Keka-${finalAttrs.version}.zip";
    hash = "sha256-mlQFbVzmLDnDvei7YYtafP+MD0lzpGZQJuWfkvIHwGw=";
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

  __structuredAttrs = true;
  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS file archiver";
    homepage = "https://www.keka.io";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      emilytrau
      myzel394
    ];
    platforms = lib.platforms.darwin;
  };
})
