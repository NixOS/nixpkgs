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
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H43DGVYqUnhi3K7hKZhJBZ5Lfx2RczB7S9yO8Oe19ZQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/src/yhub-server";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/src/yhub-server/yarn.lock";
    hash = "sha256-OSGTfwVnQ8MVV4GRuj9O5zY1/C8LyMbdybj1SqQB/Qg=";
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

  installPhase = let
    yhubPatches = [
      ./allow-db-configuration-without-postgres-conf-parameter.patch
    ];
  in ''
    runHook preInstall

    mkdir -p $out/{lib,bin}
    cp -r dist node_modules $out/lib

    pushd $out/lib/node_modules/@y/hub
    ${lib.concatStringsSep "\n" (map (patch: "patch --strip=1 -i ${patch}") yhubPatches)}
    popd

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
