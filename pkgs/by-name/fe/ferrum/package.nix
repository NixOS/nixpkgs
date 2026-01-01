{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "200";
in
stdenvNoCC.mkDerivation {
  pname = "ferrum";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://dotcolon.net/files/fonts/ferrum_${majorVersion}${minorVersion}.zip";
=======
    url = "https://dotcolon.net/download/fonts/ferrum_${majorVersion}${minorVersion}.zip";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-NDJwgFWZgyhMkGRWlY55l2omEw6ju3e3dHCEsWNzQIc=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://dotcolon.net/font/ferrum/";
    description = "Decorative font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      minijackson
    ];
    license = lib.licenses.cc0;
=======
  meta = with lib; {
    homepage = "http://dotcolon.net/font/ferrum/";
    description = "Decorative font";
    platforms = platforms.all;
    maintainers = with maintainers; [
      minijackson
    ];
    license = licenses.cc0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
