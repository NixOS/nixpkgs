{ lib
, buildNpmPackage
, fetchFromGitHub
, makeWrapper
, electron_27
}:

buildNpmPackage rec {
  pname = "flaci";
  version = "unstable-2023-12-21";

  src = fetchFromGitHub {
    owner = "gitmh";
    repo = "FLACI";
    rev = "6bd8541e41cca6a8020d817dd5eb7645778e80fd";
    hash = "sha256-VGd3AC+Ix0FqiaMclHkbXdSCe/5L4YTPqIL6jQIjPpk=";
  };

  # Make dependency install not fail because the electron install wants to download a binary
  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  npmDepsHash = "sha256-6X4R6D9GAe4DiIXCT62xKbHhLqdTE/BLlXJQKwt8oaQ=";

  nativeBuildInputs = [
    makeWrapper
  ];
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/flaci}
    cp -r appmenu.html favicon.ico flaci.html flaci.js flaciLogo.png i18n images index.html languageselect.html libs main.js package.json preload.js renderer.js styles views $out/share/flaci/
    makeWrapper ${electron_27}/bin/electron $out/bin/FLACI \
      --add-flags $out/share/flaci \
      --add-flags "--no-sandbox"

    runHook postInstall
  '';

  dontWrapGApps = true;

  meta = with lib; {
    description = "Create and test formal languages with automaton and create diagrams for them";
    homepage = "https://flaci.com";
    license = licenses.mit;
    maintainers = with maintainers; [ annaaurora ];
  };
}
