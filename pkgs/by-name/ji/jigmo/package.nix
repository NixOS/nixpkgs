{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jigmo";
  version = "20250912";

  src = fetchzip {
    url = "https://kamichikoichi.github.io/jigmo/Jigmo-${finalAttrs.version}.zip";
    hash = "sha256-Z9WYPqNjHqnYjRndxtHsQ9XhFshMR50hVkQsXgUMKE8=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf --target-directory=$out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Japanese Kanji font set which is the official successor to Hanazono Mincho";
    homepage = "https://kamichikoichi.github.io/jigmo/";
    license = lib.licenses.cc0;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
