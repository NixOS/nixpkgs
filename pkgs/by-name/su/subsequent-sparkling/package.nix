{ lib, stdenvNoCC, fetchzip, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "subsequent-sparkling";
  version = "0-unstable-2024-03-07";

  src = fetchzip {
    url = "https://drive.google.com/uc?export=download&id=1t1ljGAQQjllcjKDCD3MyqOiL7_3mH3cS";
    hash = "sha256-b9MA+XjNfKYWNG/s+KXIk4Yp9maqfZ7RS0ZltSGFKDo=";
    stripRoot = false;
    extension = "zip";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 *.otf -t $out/share/fonts/opentype/

    runHook postInstall
  '';

  meta = with lib; {
    description = "A manga font";
    homepage = "https://randallfonts.carrd.co/#fonts";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
