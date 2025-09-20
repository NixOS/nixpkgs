{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "annapurna-sil";
  version = "2.100";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/annapurna/AnnapurnaSIL-${finalAttrs.version}.zip";
    hash = "sha256-TFaCchtd9SRGsU9r+m8QOvZfc7/FJxwclkSfbLwf6/4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 OFL.txt OFL-FAQ.txt README.txt FONTLOG.txt -t $out/share/doc/annapurna-sil-${finalAttrs.version}

    runHook postInstall
  '';

  meta = {
    homepage = "https://software.sil.org/annapurna";
    description = "Unicode-based font family with broad support for writing systems that use the Devanagari script";
    longDescription = ''
      Annapurna SIL is a Unicode-based font family with broad support for writing systems that use the Devanagari script. Inspired by traditional calligraphic forms, the design is intended to be highly readable, reasonably compact, and visually attractive.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kmein ];
  };
})
