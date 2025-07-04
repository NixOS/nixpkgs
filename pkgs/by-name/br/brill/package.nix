{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "brill";
  version = "4.000.073";

  src = fetchzip {
    url = "https://brill.com/fileasset/The_Brill_Typeface_Package_v_4_0.zip";
    hash = "sha256-ugmEIkeBzD/4C9wkVfbctEtnzI8Kw+YD6KGcbk4BAf4=";
    stripRoot = false;
  };

  installPhase = with finalAttrs; ''
    runHook preInstall

    install -Dm644 *.ttf          -t $out/share/fonts/truetype
    install -Dm644 *agreement.pdf -t $out/share/licenses/brill
    install -Dm644 *use.pdf       -t $out/share/doc/brill

    runHook postInstall
  '';

  meta = with lib; {
    description = "In-house serif typeface for the publishing house Brill, designed by John Hudson; free for non-commercial use";
    longDescription = ''
      Brill has “a neo-classical design geared towards optimum legibility”.

      According to designer John Hudson (Tiro Typeworks):
      “the mostly vertical contrast axis and expansion stroke model of the Brill types were chosen because they favour the mirrored letters of the International Phonetic Association alphabet. There is an inherent stability in this style that makes it more easily adaptable to a wide variety of shapes than, for instance, a renaissance style type with an oblique axis and broad-nib modelling.
      Technically, the Brill fonts have to be able to legibly display any combination of the supported characters that might be encountered in text, including sequences of combining diacritic marks above and below letters, and to be able to do so in typographically sophisticated ways involving smallcaps etc. The OpenType Layout programming in the fonts includes smart contextual rules affecting the shape, spacing and mark positioning of characters. The idea is that users will be able to throw pretty much any text at these fonts and get back a legible and aesthetically pleasing display.’
    '';
    homepage = "https://brill.com/page/BrillFont/brill-typeface";
    downloadPage = "https://brill.com/page/419382";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ trespaul ];
  };
})
