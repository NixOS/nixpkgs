{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "binternet";
  version = "0-unstable-2025-11-22";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Ahwxorg";
    repo = "Binternet";
    rev = "c3a3ce76bf12b8dfabebaa14f33e46181ac199d3";
    hash = "sha256-+uiORW9TDW/rlalzCqzq7VW6s/xJ2KPoG8ojF7ZWPm8=";
  };

  # PHP application, no build step
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${finalAttrs.pname}
    cp -r . $out/share/${finalAttrs.pname}/

    runHook postInstall
  '';

  meta = {
    description = "Custom Pinterest frontend";
    longDescription = ''
      Personalized alternative frontend for Pinterest written in PHP,
      offering a different way to browse and view pins.
    '';
    homepage = "https://github.com/Ahwxorg/Binternet";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.all;
  };
})
