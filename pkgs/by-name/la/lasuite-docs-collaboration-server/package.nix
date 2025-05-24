{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "lasuite-docs-collaboration-server";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${version}";
    hash = "sha256-SLTNkK578YhsDtVBS4vH0E/rXx+rXZIyXMhqwr95QEA=";
  };

  sourceRoot = "source/src/frontend";

  patches = [
    # Support for $ENVIRONMENT_VARIABLE_FILE to be able to pass secret file
    # See: https://github.com/suitenumerique/docs/pull/912
    ./environment_variables.patch
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/src/frontend/yarn.lock";
    hash = "sha256-ei4xj+W2j5O675cpMAG4yCB3cPLeYwMhqKTacPWFjoo=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
    makeWrapper
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock

    # Fixup what fixup-yarn-lock does not fix. Result in error if not fixed.
    substituteInPlace yarn.lock \
      --replace-fail '"@fastify/otel@https://codeload.github.com/getsentry/fastify-otel/tar.gz/ae3088d65e286bdc94ac5d722573537d6a6671bb"' '"@fastify/otel@^0.8.0"'

    yarn install \
        --frozen-lockfile \
        --force \
        --production=false \
        --ignore-engines \
        --ignore-platform \
        --ignore-scripts \
        --no-progress \
        --non-interactive \
        --offline

    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline COLLABORATION_SERVER run build

    runHook postBuild
  '';

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
    description = "A collaborative note taking, wiki and documentation platform that scales. Built with Django and React. Opensource alternative to Notion or Outline";
    homepage = "https://github.com/suitenumerique/docs";
    changelog = "https://github.com/suitenumerique/docs/blob/${src.tag}/CHANGELOG.md";
    mainProgram = "docs-collaboration-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
