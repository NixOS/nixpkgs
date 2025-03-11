{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "beedii";

  # 1.2.0 does not include font files.
  # https://github.com/webkul/beedii/issues/1
  version = "1.0.0";

  src = fetchzip {
    url = "https://github.com/webkul/beedii/releases/download/v${version}/beedii.zip";
    hash = "sha256-MefkmWl7LdhQiePpixKcatoIeOTlrRaO3QA9xWAxJ4Q=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 Fonts/*.ttf -t $out/share/fonts/truetype/${pname}

    runHook postInstall
  '';

  meta = {
    description = "Free Hand Drawn Emoji Font";
    homepage = "https://github.com/webkul/beedii";
    license = lib.licenses.cc0;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      kachick
    ];
  };
}
