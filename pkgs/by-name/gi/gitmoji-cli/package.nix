{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, prefetch-yarn-deps
, yarn
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitmoji-cli";
  version = "8.5.0";

  src = fetchFromGitHub {
    owner = "carloscuesta";
    repo = "gitmoji-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZM6jOi0FnomkIZeK6ln1Z0d6R5cjav67qyly3yqR1HQ=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-HSAWFVOTlXlG7N5591hpfPAYaSrP413upW5u/HN9X2o=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    prefetch-yarn-deps
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/gitmoji-cli"
    cp -r lib node_modules "$out/lib/node_modules/gitmoji-cli"

    makeWrapper "${nodejs}/bin/node" "$out/bin/gitmoji" \
      --add-flags "$out/lib/node_modules/gitmoji-cli/lib/cli.js"

    runHook postInstall
  '';

  meta = {
    description = "Gitmoji client for using emojis on commit messages";
    homepage = "https://github.com/carloscuesta/gitmoji-cli";
    license = lib.licenses.mit;
    mainProgram = "gitmoji";
    maintainers = with lib.maintainers; [ nequissimus ];
  };
})
