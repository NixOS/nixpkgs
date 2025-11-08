{
  lib,
  stdenvNoCC,
  fetchzip,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "beedii";
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

  passthru.updateScript = gitUpdater {
    url = "https://github.com/webkul/beedii";
    rev-prefix = "v";

    # This version does not include font files in the released assets.
    # https://github.com/webkul/beedii/issues/1
    ignoredVersions = "^1\.2\.0$";
  };

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
