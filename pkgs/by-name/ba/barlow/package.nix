{
  lib,
  stdenvNoCC,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchzip,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenvNoCC.mkDerivation rec {
  pname = "barlow";
  version = "1.422";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "jpt";
    repo = "barlow";
    tag = "${version}";
    hash = "sha256-FG68o6qN/296RhSNDHFXYXbkhlXSZJgGhVjzlJqsksY=";
=======
  src = fetchzip {
    url = "https://tribby.com/fonts/barlow/download/barlow-${version}.zip";
    stripRoot = false;
    hash = "sha256-aHAGPEgBkH41r7HR0D74OGCa7ta7Uo8Mgq4YVtYOwU8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/otf/*.otf -t $out/share/fonts/opentype
    install -Dm644 fonts/ttf/*.ttf fonts/gx/*.ttf -t $out/share/fonts/truetype
    install -Dm644 fonts/eot/*.eot -t $out/share/fonts/eot
    install -Dm644 fonts/woff/*.woff -t $out/share/fonts/woff
    install -Dm644 fonts/woff2/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Grotesk variable font superfamily";
    homepage = "https://tribby.com/fonts/barlow/";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Grotesk variable font superfamily";
    homepage = "https://tribby.com/fonts/barlow/";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
