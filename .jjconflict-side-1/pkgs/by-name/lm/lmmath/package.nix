{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "lmmath";
  version = "1.959";

  src = fetchzip {
    url = "http://www.gust.org.pl/projects/e-foundry/lm-math/download/latinmodern-math-1959.zip";
    hash = "sha256-et/WMhfZZYgP0S7ZmI6MZK5owv9bSoMBXFX6yGSng5Y=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype/
    mkdir -p $out/share/doc/latinmodern-math-${version}/
    cp otf/*.otf $out/share/fonts/opentype/
    cp doc/*.txt $out/share/doc/latinmodern-math-${version}/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Latin Modern Math (LM Math) font completes the modernization of the Computer Modern family of typefaces designed and programmed by Donald E. Knuth";
    homepage = "http://www.gust.org.pl/projects/e-foundry/lm-math";
    # "The Latin Modern Math font is licensed under the GUST Font License (GFL),
    # which is a free license, legally equivalent to the LaTeX Project Public
    # License (LPPL), version 1.3c or later." - GUST website
    license = licenses.lppl13c;
    maintainers = with maintainers; [ siddharthist ];
    platforms = platforms.all;
  };
}
