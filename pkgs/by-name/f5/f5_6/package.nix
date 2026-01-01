{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "110";
in
stdenvNoCC.mkDerivation {
  pname = "f5_6";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://dotcolon.net/files/fonts/f5_6_${majorVersion}${minorVersion}.zip";
=======
    url = "https://dotcolon.net/download/fonts/f5_6_${majorVersion}${minorVersion}.zip";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-FeCU+mzR0iO5tixI72XUnhvpGj+WRfKyT3mhBtud3uE=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://dotcolon.net/font/f5_6/";
    description = "Weighted decorative font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      minijackson
    ];
    license = lib.licenses.ofl;
=======
  meta = with lib; {
    homepage = "http://dotcolon.net/font/f5_6/";
    description = "Weighted decorative font";
    platforms = platforms.all;
    maintainers = with maintainers; [
      minijackson
    ];
    license = licenses.ofl;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
