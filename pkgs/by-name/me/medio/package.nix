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
  pname = "medio";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://dotcolon.net/files/fonts/medio_${majorVersion}${minorVersion}.zip";
=======
    url = "https://dotcolon.net/download/fonts/medio_${majorVersion}${minorVersion}.zip";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-S+CcwD4zGVk7cIFD6K4NnpE/0mrJq4RnDJC576rhcLQ=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://dotcolon.net/font/medio/";
=======
  meta = with lib; {
    homepage = "http://dotcolon.net/font/medio/";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Serif font designed by Sora Sagano";
    longDescription = ''
      Medio is a serif font designed by Sora Sagano, based roughly
      on the proportions of the font Tenderness (from the same designer),
      but with hairline serifs in the style of a Didone.
    '';
<<<<<<< HEAD
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      minijackson
    ];
    license = lib.licenses.cc0;
=======
    platforms = platforms.all;
    maintainers = with maintainers; [
      minijackson
    ];
    license = licenses.cc0;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
