{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  yarnConfigHook,
}:

stdenv.mkDerivation rec {
  pname = "lasuite-drive-frontend";
  version = "unstable-2025-05-22";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "drive";
    rev = "3379fde82abc4abd81d16d63fd08a4bdadaf55b4";
    hash = "sha256-JFpYaE6JGhVCviux7ZiBHTF9ccPEbNj2/+CRR1oW8as=";
  };

  sourceRoot = "source/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/src/frontend/yarn.lock";
    hash = "sha256-nQq9CVmAKA2EGdhH/RnOJ0/+tNEJUiZ/QSensdl45rg=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
    yarnConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    yarn --offline workspace drive run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r apps/drive/out/ $out

    runHook postInstall
  '';

  meta = {
    description = "A collaborative file sharing and document management platform that scales. Built with Django and React. Opensource alternative to Sharepoint or Google Drive";
    homepage = "https://github.com/suitenumerique/drive";
    changelog = "https://github.com/suitenumerique/drive/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
