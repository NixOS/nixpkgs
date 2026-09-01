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
  pname = "lasuite-docs-collaboration-server";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NR4TooBjE9hTZOm830MRtebUtSZFxVsVwswPz1w8k48=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/src/frontend/yarn.lock";
    hash = "sha256-1WqEF1M3YHt7IgoBe9WjX/kL1knfvOWWSli2K5V+gm4=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
    yarnConfigHook
    yarnBuildHook
    makeWrapper
  ];

  yarnBuildScript = "COLLABORATION_SERVER";
  yarnBuildFlags = "run build";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,bin}
    cp -r {apps,node_modules,packages,servers} $out/lib

    makeWrapper ${lib.getExe nodejs} "$out/bin/docs-collaboration-server" \
      --add-flags "$out/lib/servers/y-provider/dist/start-server.js" \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  meta = {
    description = "Collaborative note taking, wiki and documentation platform that scales. Built with Django and React. Opensource alternative to Notion or Outline";
    homepage = "https://github.com/suitenumerique/docs";
    changelog = "https://github.com/suitenumerique/docs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "docs-collaboration-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      soyouzpanda
      ma27
    ];
    platforms = lib.platforms.linux;
  };
})
