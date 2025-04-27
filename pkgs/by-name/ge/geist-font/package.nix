{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "geist-font";
  version = "1.4.01";

  srcs = [
    (fetchzip {
      name = "geist-mono";
      url = "https://github.com/vercel/geist-font/releases/download/${finalAttrs.version}/GeistMono-${finalAttrs.version}.zip";
      stripRoot = false;
      hash = "sha256-NVPSG2Flm78X5+KXUqlTiGrquD/FGuI1C3PFcIqdyl8=";
    })
    (fetchzip {
      name = "geist-sans";
      url = "https://github.com/vercel/geist-font/releases/download/${finalAttrs.version}/Geist-v${finalAttrs.version}.zip";
      stripRoot = false;
      hash = "sha256-r3Ix+UhxL/UosCLsWl52N55D+rGonQK9TIRfu4hGiwE=";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -D geist-{mono,sans}/*/otf/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    description = "Font family created by Vercel in collaboration with Basement Studio";
    homepage = "https://vercel.com/font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ x0ba ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
