{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "readexpro";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "ThomasJockin";
    repo = "readexpro";
    rev = "563dfbb36ae45e52ec50829b016ce724ac2fca70";
    # Upstream repository does not have any tagged releases. The version number seems to only be mentioned in the README.md.
    hash = "sha256-+CLym2N2O6Opv7pxuVA+sfiENggPD5HRJrVByzaMMN8=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/
    cp -r $src/fonts/. $out/share/fonts/

    runHook postInstall
  '';

  meta = {
    description = "World-script expansion of Lexend";
    longDescription = ''
      Readex is the world-script expansion of the font Lexend designed by Thomas Jockin and Nadine Chahine. Readex currently supports Latin and Arabic.

      Lexend is a variable typeface designed by Bonnie Shaver-Troup and Thomas Jockin in 2018. Applying the Shaver-Troup Individually Optimal Text Formation Factors, studies have found readers instantaneously improve their reading fluency.

      This font is based on the Quicksand project from Andrew Paglinawan, initiated in 2008. Quicksand was improved in 2016 by Thomas Jockin for Google Fonts. Thomas modified Quicksand for the specialized task of improving reading fluency in low-proficiency readers (including those with dyslexia.)
    '';
    homepage = "http://www.lexend.com/";

    # The fetched Font Software is licensed under the SIL Open Font License, Version 1.1.
    # see https://scripts.sil.org/OFL
    license = lib.licenses.ofl;

    platforms = lib.platforms.all;

    maintainers = with lib.maintainers; [ S-K-Tiger ];
  };
}
