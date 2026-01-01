{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "102";
in
stdenvNoCC.mkDerivation {
  pname = "aileron";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://dotcolon.net/files/fonts/aileron_${majorVersion}${minorVersion}.zip";
=======
    url = "https://dotcolon.net/download/fonts/aileron_${majorVersion}${minorVersion}.zip";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-Ht48gwJZrn0djo1yl6jHZ4+0b710FVwStiC1Zk5YXME=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://dotcolon.net/font/aileron/";
    description = "Helvetica font in nine weights";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      minijackson
    ];
    license = lib.licenses.cc0;
=======
  meta = with lib; {
    homepage = "http://dotcolon.net/font/aileron/";
    description = "Helvetica font in nine weights";
    platforms = platforms.all;
    maintainers = with maintainers; [
      minijackson
    ];
    license = licenses.cc0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
