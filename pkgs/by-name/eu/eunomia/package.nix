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
  pname = "eunomia";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://dotcolon.net/files/fonts/eunomia_${majorVersion}${minorVersion}.zip";
=======
    url = "https://dotcolon.net/download/fonts/eunomia_${majorVersion}${minorVersion}.zip";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-Rd2EakaTWjzoEV00tHTgg/bXgJUFfPjCyQUWi7QhFG4=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://dotcolon.net/font/eunomia/";
    description = "Futuristic decorative font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      minijackson
    ];
    license = lib.licenses.ofl;
=======
  meta = with lib; {
    homepage = "http://dotcolon.net/font/eunomia/";
    description = "Futuristic decorative font";
    platforms = platforms.all;
    maintainers = with maintainers; [
      minijackson
    ];
    license = licenses.ofl;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
