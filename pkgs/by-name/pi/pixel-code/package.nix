{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pixel-code";
  version = "2.2";

  src = fetchzip {
    url = "https://github.com/qwerasd205/PixelCode/releases/download/v${version}/otf.zip";
    hash = "sha256-GNYEnv0bIWz5d8821N46FD2NBNBf3Dd7DNqjSdJKDoE=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/otf/*.otf

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/qwerasd205/PixelCode";
    description = "Pixel font designed to actually be good for programming";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ mattpolzin ];
  };
}
