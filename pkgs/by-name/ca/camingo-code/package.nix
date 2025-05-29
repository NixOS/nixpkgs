{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "camingo-code";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/chrissimpkins/codeface/releases/download/font-collection/codeface-fonts.zip";
    hash = "sha256-oo5pWDq6h0bmyGvfF9Bkh7WyjKX4dG8uclfIsWLhDw8=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 camingo-code/*.ttf -t $out/share/fonts/truetype
    install -Dm644 camingo-code/*.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.myfonts.com/fonts/jan-fromm/camingo-code/";
    description = "Monospaced typeface designed for source-code editors";
    platforms = platforms.all;
    license = licenses.cc-by-nd-30;
  };
}
