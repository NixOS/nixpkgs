{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "charis";
  version = "7.000";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/charis/Charis-${finalAttrs.version}.zip";
    hash = "sha256-cVz0U2PAIl8FqT/HhvDNoWg3SCwKQ1e7rdk+dkP1Cc8=";
  };

  installPhase = ''
    runHook preInstall

    install -D --mode 444 --target-directory $out/share/fonts/truetype *.ttf
    install -D --mode 444 --target-directory $out/share/doc/charis-${finalAttrs.version} \
      OFL.txt OFL-FAQ.txt README.txt FONTLOG.txt

    runHook postInstall
  '';

  meta = {
    homepage = "https://software.sil.org/charis";
    description = "Family of highly readable fonts for broad multilingual use";
    longDescription = ''
      This Charis font is essentially the same design as the SIL Charis font
      first released by SIL in 1997. Charis is similar to Bitstream Charter,
      one of the first fonts designed specifically for laser printers. It is
      highly readable and holds up well in less-than-ideal reproduction
      environments. It also has a full set of styles – regular, italic, bold,
      bold italic. Charis is a serif, proportionally-spaced font optimized for
      readability in long printed documents.

      The goal for this product was to provide a single Unicode-based font
      family that would contain a comprehensive inventory of glyphs needed for
      almost any Roman- or Cyrillic-based writing system, whether used for
      phonetic or orthographic needs. In addition, there is provision for other
      characters and symbols useful to linguists. This font makes use of
      state-of-the-art font technologies to support complex typographic issues,
      such as the need to position arbitrary combinations of base glyphs and
      diacritics optimally.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.f--t ];
  };
})
