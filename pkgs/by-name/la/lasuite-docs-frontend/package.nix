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

stdenv.mkDerivation (finalAttrs: {
  pname = "lasuite-docs-frontend";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H43DGVYqUnhi3K7hKZhJBZ5Lfx2RczB7S9yO8Oe19ZQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/src/frontend/yarn.lock";
    hash = "sha256-HFKvnYr74cA0KKlhbRenEIIK7ER+Xrvtr6zBJ7yQ9lc=";
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
    changelog = "https://github.com/suitenumerique/docs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      soyouzpanda
      ma27
    ];
    platforms = lib.platforms.linux;
  };
})
