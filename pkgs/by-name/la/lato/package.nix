{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "lato";
  version = "2.0";

  src = fetchzip {
<<<<<<< HEAD
    url = "https://www.latofonts.com/files/Lato2OFL.zip";
    hash = "sha256-n1TsqigCQIGqyGLGTjLtjHuBf/iCwRlnqh21IHfAuXI=";
    stripRoot = false;
=======
    url = "https://www.latofonts.com/download/Lato2OFL.zip";
    stripRoot = false;
    hash = "sha256-n1TsqigCQIGqyGLGTjLtjHuBf/iCwRlnqh21IHfAuXI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    install -Dm644 Lato2OFL/*.ttf \
      --target-directory=$out/share/fonts/lato
=======
    install -Dm644 Lato2OFL/*.ttf -t $out/share/fonts/lato
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://www.latofonts.com";
    description = "Sans-serif typeface family designed in Summer 2010 by Łukasz Dziedzic";
    longDescription = ''
      Lato is a sans-serif typeface family designed in the Summer 2010
      by Warsaw-based designer Łukasz Dziedzic ("Lato" means "Summer"
      in Polish).  In December 2010 the Lato family was published
      under the open-source Open Font License by his foundry tyPoland,
      with support from Google.

      In 2013-2014, the family was greatly extended to cover 3000+
      glyphs per style. The Lato 2.010 family now supports 100+
      Latin-based languages, 50+ Cyrillic-based languages as well as
      Greek and IPA phonetics. In the process, the metrics and kerning
      of the family have been revised and four additional weights were
      created.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ chris-martin ];
=======
  meta = with lib; {
    homepage = "https://www.latofonts.com/";

    description = ''
      Sans-serif typeface family designed in Summer 2010 by Łukasz Dziedzic
    '';

    longDescription = ''
      Lato is a sans-serif typeface family designed in the Summer 2010 by
      Warsaw-based designer Łukasz Dziedzic ("Lato" means "Summer" in Polish).
      In December 2010 the Lato family was published under the open-source Open
      Font License by his foundry tyPoland, with support from Google.

      In 2013-2014, the family was greatly extended to cover 3000+ glyphs per
      style. The Lato 2.010 family now supports 100+ Latin-based languages, 50+
      Cyrillic-based languages as well as Greek and IPA phonetics. In the
      process, the metrics and kerning of the family have been revised and four
      additional weights were created.
    '';

    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ chris-martin ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
