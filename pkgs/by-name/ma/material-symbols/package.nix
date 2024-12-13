{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rename,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
  version = "4.0.0-unstable-2024-05-17";

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "ace1af08508a6562ef05055a606cf44ea583ce3b";
    hash = "sha256-d5lojgYCXCcvcSfLWfcSKFsBGKB6Si/XreRqpkEKsa0=";
    sparseCheckout = [ "variablefont" ];
  };

  nativeBuildInputs = [ rename ];

  installPhase = ''
    runHook preInstall

    rename 's/\[FILL,GRAD,opsz,wght\]//g' variablefont/*
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
    ];
    platforms = lib.platforms.all;
  };
}
