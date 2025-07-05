{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "lasuite-meet-frontend";
  version = "0.1.27";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "meet";
    tag = "v${version}";
    hash = "sha256-EMhsQPrONaQmNJ/FFoYlP5KKXT8vm7LwUHmEZd0oZeE=";
  };

  sourceRoot = "source/src/frontend";

  npmDeps = fetchNpmDeps {
    inherit version src;
    sourceRoot = "source/src/frontend";
    hash = "sha256-7wXzcn6aGAkRUOCI6MU0AlPGngBWJtdbAfnZZDaMWec=";
  };

  buildPhase = ''
    runHook preBuild

    npm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Open source alternative to Google Meet and Zoom powered by LiveKit: HD video calls, screen sharing, and chat features. Built with Django and React";
    homepage = "https://github.com/suitenumerique/meet";
    changelog = "https://github.com/suitenumerique/meet/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
