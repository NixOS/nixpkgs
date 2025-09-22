{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "kanit";
  version = "0-unstable-2020-06-16";

  src = fetchFromGitHub {
    owner = "cadsondemak";
    repo = "kanit";
    rev = "467dfe842185681d8042cd608b8291199dd37cda";
    sha256 = "0p0klb0376r8ki4ap2j99j7jcsq6wgb7m1hf3j1dkncwm7ikmg3h";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/doc/kanit/css/ $out/share/fonts/{opentype,truetype}

    cp $src/OFL.txt $src/documentation/{BRIEF.md,features.html} $out/share/doc/kanit
    cp $src/documentation/css/fonts.css $out/share/doc/kanit/css
    cp $src/fonts/otf/*.otf $out/share/fonts/opentype
    cp $src/fonts/ttf/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://cadsondemak.github.io/kanit/";
    description = "Loopless Thai and sans serif Latin typeface for contemporary and futuristic uses";
    longDescription = ''
      Kanit means mathematics in Thai, and the Kanit typeface family is a formal
      Loopless Thai and Sans Latin design. It is a combination of concepts,
      mixing a Humanist Sans Serif motif with the curves of Capsulated Geometric
      styles that makes it suitable for various uses, contemporary and
      futuristic. A notable detail is that the stroke terminals have flat angles,
      which allows the design to enjoy decreased spacing between letters while
      preserving readability and legibility at smaller point sizes.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.toastal ];
  };
}
