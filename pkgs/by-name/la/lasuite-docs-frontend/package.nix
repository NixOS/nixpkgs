{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  yarnConfigHook,
  yarnBuildHook,
}:

stdenv.mkDerivation rec {
  pname = "lasuite-docs-frontend";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${version}";
    hash = "sha256-rhbS6NYk8sZmtrNpKJrm24vOwAJGEDVS9fpFWuyvPGA=";
  };

  sourceRoot = "source/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/src/frontend/yarn.lock";
    hash = "sha256-ZMeLHpwM0yZvYmA/HSuWbcdqxOH707NNzXppEzV2wEw=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
    yarnConfigHook
    yarnBuildHook
  ];

  yarnBuildScript = "app:build";

  installPhase = ''
    runHook preInstall

    cp -r apps/impress/out/ $out

    runHook postInstall
  '';

  meta = {
    description = "Collaborative note taking, wiki and documentation platform that scales. Built with Django and React. Opensource alternative to Notion or Outline";
    homepage = "https://github.com/suitenumerique/docs";
    changelog = "https://github.com/suitenumerique/docs/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
