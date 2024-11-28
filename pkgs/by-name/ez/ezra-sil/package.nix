{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "ezra-sil";
  version = "2.51";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/ezra/EzraSIL-${version}.zip";
    hash = "sha256-hGOHjvFVFLwyVkcoUz+7rQekCdn4oEOB+L16XRpthJM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype
    install -Dm644 OFL-FAQ.txt README.txt FONTLOG.txt -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://software.sil.org/ezra";
    description = "Typeface fashioned after the square letter forms of the typography of the Biblia Hebraica Stuttgartensia (BHS)";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
  };
}
