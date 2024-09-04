{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "departure-mono";
  version = "1.346";

  src = fetchzip {
    url = "https://departuremono.com/assets/DepartureMono-${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-xJVVtLnukcWQKVC3QiHvrfIA3W9EYt/iiphbLYT1iMg=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m 444 *.otf -t $out/share/fonts/otf
    install -D -m 444 *.woff -t $out/share/fonts/woff
    install -D -m 444 *.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  meta = {
    description = "Departure Mono is a monospaced pixel font with a lo-fi technical vibe";
    homepage = "https://departuremono.com/";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
