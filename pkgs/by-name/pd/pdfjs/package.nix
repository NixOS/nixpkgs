{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pdfjs";
  version = "6.4.299";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/mozilla/pdf.js/releases/download/v${finalAttrs.version}/pdfjs-${finalAttrs.version}-dist.zip";
    hash = "sha256-UHMYW6fHRL7by4sP7NXE5NuTKtmUPfInK6KunbnP88w=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/pdf.js
    cp -r build web LICENSE $out/share/pdf.js/
    runHook postInstall
  '';

  meta = {
    description = "JavaScript PDF reader and viewer";
    homepage = "https://mozilla.github.io/pdf.js/";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ schembriaiden ];
    platforms = lib.platforms.all;
  };
})
