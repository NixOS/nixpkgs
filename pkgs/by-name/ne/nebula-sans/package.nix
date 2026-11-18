{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nebula-sans";
  version = "1.010";

  src = fetchzip {
    url = "https://nebulasans.com/download/NebulaSans-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-jFoHgxczU7VdZcVj7HI4OOjK28jcptu8sGOrs3O+0S0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mv TTF/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Versatile, modern, humanist sans-serif with a neutral aesthetic, designed for legibility in both digital and print applications";
    maintainers = [ lib.maintainers.colemickens ];
    platforms = lib.platforms.all;
    homepage = "https://nebulasans.com/";
    license = lib.licenses.ofl;
  };
})
