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

  meta = with lib; {
    description = "Two-element sans-serif typeface, created by Małgorzata Budyta";
    homepage = "https://jmn.pl/en/kurier-i-iwona/";
    # "[...] GUST Font License (GFL), which is a free license, legally
    # equivalent to the LaTeX Project Public # License (LPPL), version 1.3c or
    # later." - GUST website
    license = src.meta.license;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
