{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "courier-prime";
  version = "unstable-2019-12-05";

  src = fetchzip {
    url = "https://github.com/quoteunquoteapps/CourierPrime/archive/7f6d46a766acd9391d899090de467c53fd9c9cb0/${pname}-${version}.zip";
    hash = "sha256-pMFZpytNtgoZrBj2Gj8SgJ0Lab8uVY5aQtcO2lFbHj4=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Monospaced font designed specifically for screenplays";
    homepage = "https://github.com/quoteunquoteapps/CourierPrime";
    license = licenses.ofl;
    maintainers = [ maintainers.austinbutler ];
    platforms = platforms.all;
  };
}
