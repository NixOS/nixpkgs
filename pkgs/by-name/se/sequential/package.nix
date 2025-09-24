{
  lib,
  fetchurl,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sequential";
  version = "2.6.0";

  buildDate = "2024-09-07.14.59.00";

  src = fetchurl {
    url = "https://github.com/chuchusoft/Sequential/releases/download/v${finalAttrs.version}/Sequential.app.${finalAttrs.buildDate}.tar.xz";
    hash = "sha256-tgpzMAHw266UhKo43GIHFCx/SDq/zIJkWz1TPYTeTzI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/Sequential.app
    cp -R Sequential.app $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "macOS native comic reader and image viewer";
    homepage = "https://github.com/chuchusoft/Sequential";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ Enzime ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
