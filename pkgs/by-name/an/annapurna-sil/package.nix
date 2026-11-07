{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "annapurna-sil";
  version = "3.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/annapurna/AnnapurnaSIL-${finalAttrs.version}.zip";
    hash = "sha256-UlUDerAJvur1txGtRt0EHqZJkR1p1ylxYpq6Dtu7YME=";
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
    maintainers = [ lib.maintainers.kmein ];
  };
})
