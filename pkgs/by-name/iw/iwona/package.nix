{
  lib,
  stdenvNoCC,
  texlive,
}:

stdenvNoCC.mkDerivation rec {
  inherit (src) pname version;

  src = texlive.pkgs.iwona;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src/fonts/opentype/nowacki/iwona/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Two-element sans-serif typeface, created by Małgorzata Budyta";
    homepage = "https://jmn.pl/en/kurier/";
    # "[...] GUST Font License (GFL), which is a free license, legally
    # equivalent to the LaTeX Project Public # License (LPPL), version 1.3c or
    # later." - GUST website
    license = src.meta.license;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ siddharthist ];
    platforms = lib.platforms.all;
=======
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
