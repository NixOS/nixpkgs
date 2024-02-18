{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, rustPlatform
, cargo
, makeWrapper
, napi-rs-cli
, nodejs
, prefetch-yarn-deps
, rustc
, yarn
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parcel";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "parcel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4GMEBXgiXqNeDXCGvNgT3wp2ejOHloWVkRNafywsQ1c=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-2WsmBWff5tFsnHpdIOQaKRvv7/3DIbVsBxzym4fStUw=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "es-module-lexer-0.1.0" = "sha256-qmhZjVqgh3jOd9vQWqZ8yoJ2+SwKECtbfd973ADO7oE=";
    };
  };

  nativeBuildInputs = [
    cargo
    makeWrapper
    napi-rs-cli
    nodejs
    prefetch-yarn-deps
    rustc
    rustPlatform.cargoSetupHook
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME="$TEMP"
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules packages/core/parcel/src/bin.js

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build-native-release
    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive --production install

    mkdir -p "$out/lib/node_modules/parcel"
    cp -r . "$out/lib/node_modules/parcel"

    makeWrapper "${lib.getExe nodejs}" "$out/bin/parcel" \
      --add-flags "$out/lib/node_modules/parcel/packages/core/parcel/lib/bin.js"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/parcel-bundler/parcel/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Zero configuration web application bundler";
    homepage = "https://github.com/parcel-bundler/parcel";
    license = lib.licenses.mit;
    mainProgram = "parcel";
    maintainers = with lib.maintainers; [ ];
  };
})
