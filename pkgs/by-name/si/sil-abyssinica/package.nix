{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sil-abyssinica";
  version = "2.201";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/abyssinica/AbyssinicaSIL-${version}.zip";
    hash = "sha256-DJWp3T9uBLnztSq9r5YCSWaBjIK/0Aljg1IiU0FLrdE=";
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
