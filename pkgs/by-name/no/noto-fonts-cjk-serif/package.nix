{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nixosTests,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "noto-fonts-cjk-serif";
  version = "2.002";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "noto-cjk";
    rev = "Serif${version}";
    hash = "sha256-GLjpTAiHfygj1J4AdUVDJh8kykkFOglq+h4kyat5W9s=";
    sparseCheckout = [ "Serif/Variable/OTC" ];
  };

  installPhase = ''
    install -m444 -Dt $out/share/fonts/opentype/noto-cjk Serif/Variable/OTC/*.otf.ttc
  '';

  passthru.tests.noto-fonts = nixosTests.noto-fonts;

  passthru.updateScript = gitUpdater {
    rev-prefix = "Serif";
  };

  meta = with lib; {
    description = "Beautiful and free fonts for CJK languages";
    homepage = "https://www.google.com/get/noto/help/cjk/";
    longDescription = ''
      Noto Serif CJK is a serif typeface designed as
      an intermediate style between the modern and traditional. It is
      intended to be a multi-purpose digital font for user interface
      designs, digital content, reading on laptops, mobile devices, and
      electronic books. Noto Serif CJK comprehensively covers
      Simplified Chinese, Traditional Chinese, Japanese, and Korean in a
      unified font family. It supports regional variants of ideographic
      characters for each of the four languages. In addition, it supports
      Japanese kana, vertical forms, and variant characters (itaiji); it
      supports Korean hangeul — both contemporary and archaic.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [
      mathnerd314
      emily
    ];
  };
}
