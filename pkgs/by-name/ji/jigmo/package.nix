{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "jigmo";
<<<<<<< HEAD
  version = "20250912";

  src = fetchzip {
    url = "https://kamichikoichi.github.io/jigmo/Jigmo-${version}.zip";
    hash = "sha256-Z9WYPqNjHqnYjRndxtHsQ9XhFshMR50hVkQsXgUMKE8=";
    stripRoot = false;
=======
  version = "20230816";

  src = fetchzip {
    url = "https://kamichikoichi.github.io/jigmo/Jigmo-${version}.zip";
    hash = "sha256-wBec7IiUneqCEyY704Wi6F6WG0Z1KK7gBGcJhRjrRDc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Japanese Kanji font set which is the official successor to Hanazono Mincho";
    homepage = "https://kamichikoichi.github.io/jigmo/";
    license = lib.licenses.cc0;
    maintainers = [ ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Japanese Kanji font set which is the official successor to Hanazono Mincho";
    homepage = "https://kamichikoichi.github.io/jigmo/";
    license = licenses.cc0;
    maintainers = [ ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
