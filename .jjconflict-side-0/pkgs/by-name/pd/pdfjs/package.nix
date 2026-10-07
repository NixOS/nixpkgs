{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pdfjs";
  version = "6.5.438";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/mozilla/pdf.js/releases/download/v${finalAttrs.version}/pdfjs-${finalAttrs.version}-dist.zip";
    hash = "sha256-KNYi+V7BD9yN6+YaJ8hvMncFMUBDEtRSQx7rVt2+TlI=";
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
