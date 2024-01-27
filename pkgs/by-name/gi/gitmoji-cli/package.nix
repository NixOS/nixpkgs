{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeWrapper
, nodejs
, prefetch-yarn-deps
, yarn
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gitmoji-cli";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "carloscuesta";
    repo = "gitmoji-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cIc0AaP1AwhoVJLnonC9qvDWNZW4L6/jsQ3Q6z5VXI0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-HXMRCTiUti/GZ1dzd+XbFOao3+QLC1t7H0TT9MS5lz4=";
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
    cp -r lib node_modules package.json "$out/lib/node_modules/gitmoji-cli"

    makeWrapper "${nodejs}/bin/node" "$out/bin/gitmoji" \
      --add-flags "$out/lib/node_modules/gitmoji-cli/lib/cli.js"

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Gitmoji client for using emojis on commit messages";
    homepage = "https://github.com/carloscuesta/gitmoji-cli";
    license = lib.licenses.mit;
    mainProgram = "gitmoji";
    maintainers = with lib.maintainers; [ nequissimus ];
  };
})
