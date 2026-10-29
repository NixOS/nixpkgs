{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gentium-book-basic";
  version = "1.102";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/gentium/GentiumBasic_${lib.versions.major finalAttrs.version}${lib.versions.minor finalAttrs.version}.zip";
    hash = "sha256-oCmpl95MJRfCV25cg/4cf8AwQWnoymXasSss1ziOPoE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf                       -t $out/share/fonts/truetype
    install -Dm644 FONTLOG.txt GENTIUM-FAQ.txt -t $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}

    runHook postInstall
  '';

  meta = {
    homepage = "https://software.sil.org/gentium/";
    description = "High-quality typeface family for Latin, Cyrillic, and Greek";
    maintainers = [ ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
