{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "norwester";
  version = "1.2";

  src = fetchzip {
    url = "https://jamiewilson.github.io/norwester/assets/norwester.zip";
    stripRoot = false;
    hash = "sha256-Ak/nobrQE/XYGWs/IhlZlTp74ff+s4adUR6Sht5Yf8g=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    cp ${finalAttrs.pname}-v${finalAttrs.version}/${finalAttrs.pname}.otf $out/share/fonts/opentype/

    runHook postInstall
  '';

  meta = {
    homepage = "https://jamiewilson.github.io/norwester/";
    description = "Condensed geometric sans serif by Jamie Wilson";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
