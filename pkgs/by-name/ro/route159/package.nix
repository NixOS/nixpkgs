{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "1";
  minorVersion = "10";
in
stdenvNoCC.mkDerivation {
  pname = "route159";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://dotcolon.net/files/fonts/route159_${majorVersion}${minorVersion}.zip";
=======
    url = "https://dotcolon.net/download/fonts/route159_${majorVersion}${minorVersion}.zip";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-1InyBW1LGbp/IU/ql9mvT14W3MTxJdWThFwRH6VHpTU=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://dotcolon.net/font/route159/";
    description = "Weighted sans serif font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      minijackson
    ];
    license = lib.licenses.ofl;
=======
  meta = with lib; {
    homepage = "http://dotcolon.net/font/route159/";
    description = "Weighted sans serif font";
    platforms = platforms.all;
    maintainers = with maintainers; [
      minijackson
    ];
    license = licenses.ofl;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
