{
  lib,
  applyPatches,
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
  version = "6.1.0";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "suitenumerique";
      repo = "docs";
      tag = "v${finalAttrs.version}";
      hash = "sha256-H43DGVYqUnhi3K7hKZhJBZ5Lfx2RczB7S9yO8Oe19ZQ=";
    };

    patches = [
      ./forked-yhub.patch
    ];
  };

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/src/yhub-server";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/src/yhub-server/yarn.lock";
    hash = "sha256-eoQ6LO+vqKd0HZGkI5Q0GU8CHLH+LN3yy2vM3bM4iPI=";
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
    description = "Collaborative note taking, wiki and documentation platform";
    longDescription = ''
      A collaborative note taking, wiki and documentation platform that scales.
      Built with Django and React. Opensource alternative to Notion or Outline.
    '';
    homepage = "https://github.com/suitenumerique/docs";
    changelog = "https://github.com/suitenumerique/docs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "yhub-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.linux;
  };
})
