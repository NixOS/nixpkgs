{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2026-05-08";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "5a4e1b7fd26f11ce3d2abf7d7fcd13274f874e6c";
    hash = "sha256-XVza/duC2hsBrT6Ty1XxJy0m/lpuBt2rVoUo5B1JmUc=";
    sparseCheckout = [ "variablefont" ];
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 variablefont/*.ttf -t $out/share/fonts/TTF
    install -Dm755 variablefont/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Material Symbols icons by Google";
    homepage = "https://fonts.google.com/icons";
    downloadPage = "https://github.com/google/material-design-icons";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fufexan
      luftmensch-luftmensch
      alexphanna
    ];
    platforms = lib.platforms.all;
  };
}
