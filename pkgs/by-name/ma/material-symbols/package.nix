{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "481507587f1bdfe712939398c4dc0ecc2079ea7c";
    hash = "sha256-H95EX5hrHH0YUwC2DHIyOXXDlG3rjamUnlPznthDKFE=";
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
