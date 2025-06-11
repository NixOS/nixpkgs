{
  lib,
  fetchFromGitHub,
  stdenv,
  fetchYarnDeps,
  nodejs,
  fixup-yarn-lock,
  yarn,
}:

stdenv.mkDerivation rec {
  pname = "lasuite-docs-frontend";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "docs";
    tag = "v${version}";
    hash = "sha256-SLTNkK578YhsDtVBS4vH0E/rXx+rXZIyXMhqwr95QEA=";
  };

  sourceRoot = "source/src/frontend";

  offlineCache = fetchYarnDeps {
    yarnLock = "${src}/src/frontend/yarn.lock";
    hash = "sha256-ei4xj+W2j5O675cpMAG4yCB3cPLeYwMhqKTacPWFjoo=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
    yarn
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

    yarn --offline app:build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r apps/impress/out/ $out

    runHook postInstall
  '';

  meta = {
    description = "A collaborative note taking, wiki and documentation platform that scales. Built with Django and React. Opensource alternative to Notion or Outline";
    homepage = "https://github.com/suitenumerique/docs";
    changelog = "https://github.com/suitenumerique/docs/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    platforms = lib.platforms.all;
  };
}
