{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "pixel-code";
  version = "2.0";

  src = fetchzip {
    url = "https://github.com/qwerasd205/PixelCode/releases/download/v${version}/otf.zip";
    hash = "sha256-A84Qpd5W3sBY4mi9smqHU0PjEgroKYkQK+FaXF8QZeE=";
    stripRoot=false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/otf/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/qwerasd205/PixelCode";
    description = "A pixel font designed to actually be good for programming";
    license = licenses.ofl;
    maintainers = with maintainers; [ mattpolzin ];
  };
}
