{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ruwudu";
  version = "3.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/ruwudu/Ruwudu-${finalAttrs.version}.zip";
    hash = "sha256-HuuH6AWD5gym73zSsuQdQD901J6r3PkUmUTtnRxYRyg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{doc/${finalAttrs.pname},fonts/truetype}
    mv *.ttf $out/share/fonts/truetype/
    mv *.txt documentation $out/share/doc/${finalAttrs.pname}/

    runHook postInstall
  '';

  meta = {
    homepage = "https://software.sil.org/ruwudu/";
    description = "Arabic script font for a style of writing used in Niger, West Africa";
    license = lib.licenses.ofl;
    maintainers = [ lib.maintainers.vbgl ];
    platforms = lib.platforms.all;
  };
})
