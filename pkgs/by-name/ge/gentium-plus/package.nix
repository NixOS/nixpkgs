{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gentium-plus";
  version = "6.200";

  src = fetchzip {
    url = "http://software.sil.org/downloads/r/gentium/GentiumPlus-${finalAttrs.version}.zip";
    hash = "sha256-gpVOtmF4Kp3y1Rm00c4o3WQEskO7mY1Z5SVaYHI0hzg=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 FONTLOG.txt README.txt -t $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}
    cp -r documentation $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}

    runHook postInstall
  '';

  meta = {
    homepage = "https://software.sil.org/gentium/";
    description = "High-quality typeface family for Latin, Cyrillic, and Greek";
    longDescription = ''
      Gentium is a typeface family designed to enable the diverse ethnic groups
      around the world who use the Latin, Cyrillic and Greek scripts to produce
      readable, high-quality publications. It supports a wide range of Latin and
      Cyrillic-based alphabets.

      The design is intended to be highly readable, reasonably compact, and
      visually attractive. The additional ‘extended’ Latin letters are designed
      to naturally harmonize with the traditional 26 ones. Diacritics are
      treated with careful thought and attention to their use. Gentium Plus also
      supports both polytonic and monotonic Greek.

      This package contains the regular and italic styles for the Gentium Plus
      font family, along with documentation.
    '';
    downloadPage = "https://software.sil.org/gentium/download/";
    maintainers = with lib.maintainers; [
      raskin
      rycee
    ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
