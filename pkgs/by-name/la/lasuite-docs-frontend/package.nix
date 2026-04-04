{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchpatch,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  yarnConfigHook,
  yarnBuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lasuite-docs-frontend";
  version = "4.8.4";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k90JxFxXL3vEGBMkgbQABUCK99utJ88E/v9Zcj/2oBo=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  patches = [
    # from https://github.com/suitenumerique/docs/pull/2147,
    # fixes the frontend when using the MIT build.
    (fetchpatch {
      url = "https://github.com/suitenumerique/docs/commit/79e909cf6489428d8f6644d772006f73503b7073.patch";
      hash = "sha256-Ucw1KtsFrPvtoeeG2fH5L64Jfcog4RV38Qg+EykGcQY=";
      stripLen = 2;
    })
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/src/frontend/yarn.lock";
    hash = "sha256-ElI6WWKPCsO7Viexgp2XtcjXAXzFnG2ZPN5PjOaKO2g=";
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
    platforms = lib.platforms.all;
  };
})
