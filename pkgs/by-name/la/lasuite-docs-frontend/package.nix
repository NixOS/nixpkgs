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
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${version}";
    hash = "sha256-uo49y+tJXdc8gfFIHSIEk0DEowMsHWA64IxlHpFHUTU=";
  };

  sourceRoot = "source/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/src/frontend/yarn.lock";
    hash = "sha256-07zsggGQFX/Wx/fxs1f0w01HHx7Z2BG5d3PIBlX2SVM=";
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
