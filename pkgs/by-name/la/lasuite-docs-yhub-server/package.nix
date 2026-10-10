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
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lasuite-docs-yhub-server";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yq3Ilv/CYXGOasGR3H3Nc+rGxD4tTYfhde8Gw6rBgNc=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/yhub-server";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/src/yhub-server/yarn.lock";
    hash = "sha256-5mt0dRhAc5OBp2FlvVUIh8EJnlkO+YkZk8agEc6aPKA=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
    yarnConfigHook
    yarnBuildHook
    makeWrapper
  ];

  yarnBuildScript = "build";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,bin}
    cp -r dist node_modules $out/lib

    makeWrapper ${lib.getExe nodejs} "$out/bin/yhub-server" \
      --add-flags "--import $out/lib/dist/sentry.js $out/lib/dist/server.js" \
      --set NODE_PATH "$out/lib/node_modules"

    makeWrapper ${lib.getExe nodejs} $out/bin/y-init-db \
      --add-flags "$out/lib/node_modules/@y/hub/bin/init-db.js" \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  meta = {
    description = "Collaborative note taking, wiki and documentation platform that scales. Built with Django and React. Opensource alternative to Notion or Outline";
    homepage = "https://github.com/suitenumerique/docs";
    changelog = "https://github.com/suitenumerique/docs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "yhub-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.linux;
  };
})
