{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "norwester";
  version = "1.2";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://jamiewilson.github.io/norwester/assets/norwester.zip";
=======
    url = "http://jamiewilson.io/norwester/assets/norwester.zip";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    stripRoot = false;
    hash = "sha256-Ak/nobrQE/XYGWs/IhlZlTp74ff+s4adUR6Sht5Yf8g=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    cp ${pname}-v${version}/${pname}.otf $out/share/fonts/opentype/

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://jamiewilson.github.io/norwester/";
    description = "Condensed geometric sans serif by Jamie Wilson";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "http://jamiewilson.io/norwester";
    description = "Condensed geometric sans serif by Jamie Wilson";
    license = licenses.ofl;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
