{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nanum-gothic-coding";
  version = "2.5";

  src = fetchzip {
    url = "https://github.com/naver/nanumfont/releases/download/VER${version}/NanumGothicCoding-${version}.zip";
    stripRoot = false;
    hash = "sha256-jHbbCMUxn54iQMKdAWI3r8CDxi+5LLJh8ucQzq2Ukdc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/NanumGothicCoding
    cp *.ttf $out/share/fonts/NanumGothicCoding

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Contemporary monospaced sans-serif typeface with a warm touch";
    homepage = "https://github.com/naver/nanumfont";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Contemporary monospaced sans-serif typeface with a warm touch";
    homepage = "https://github.com/naver/nanumfont";
    license = licenses.ofl;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
