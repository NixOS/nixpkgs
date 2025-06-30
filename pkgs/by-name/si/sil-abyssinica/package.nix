{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sil-abyssinica";
  version = "2.300";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/abyssinica/AbyssinicaSIL-${version}.zip";
    hash = "sha256-3msQRxoIV1K8mjZr7xXKW54fELjNhteXZ5qg6t5+Vcg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{fonts/truetype,doc/${pname}-${version}}
    mv *.ttf $out/share/fonts/truetype/
    mv *.txt documentation $out/share/doc/${pname}-${version}/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode font for Ethiopian and Erythrean scripts (Amharic et al.)";
    homepage = "https://software.sil.org/abyssinica/";
    license = licenses.ofl;
    maintainers = with maintainers; [ serge ];
    platforms = platforms.all;
  };
}
