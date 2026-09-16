{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pdfjs";
  version = "6.3.289";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/mozilla/pdf.js/releases/download/v${finalAttrs.version}/pdfjs-${finalAttrs.version}-dist.zip";
    hash = "sha256-v8LoUEOgG8t1Al4vpKrXZ3D4HEDXd4bqRUFqUbN63qk=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/pdfjs
    cp -r build web LICENSE $out/share/pdfjs/
    runHook postInstall
  '';

  meta = {
    description = "JavaScript PDF reader and viewer";
    homepage = "https://mozilla.github.io/pdf.js/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ schembriaiden ];
    platforms = lib.platforms.all;
  };
})
