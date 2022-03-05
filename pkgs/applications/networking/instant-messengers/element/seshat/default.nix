{ lib, stdenv, rustPlatform, fetchFromGitHub, callPackage, sqlcipher, nodejs-14_x, python3, yarn, fixup_yarn_lock, CoreServices, fetchYarnDeps }:

let
  pinData = lib.importJSON ./pin.json;

in rustPlatform.buildRustPackage rec {
  pname = "seshat-node";
  inherit (pinData) version;

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "seshat";
    rev = version;
    sha256 = pinData.srcHash;
  };

  sourceRoot = "source/seshat-node/native";

  nativeBuildInputs = [ nodejs-14_x python3 yarn ];
  buildInputs = [ sqlcipher ] ++ lib.optional stdenv.isDarwin CoreServices;

  npm_config_nodedir = nodejs-14_x;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/seshat-node/yarn.lock";
    sha256 = pinData.yarnHash;
  };

  buildPhase = ''
    runHook preBuild
    cd ..
    chmod u+w . ./yarn.lock
    export HOME=$PWD/tmp
    mkdir -p $HOME
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    node_modules/.bin/neon build --release
    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall
    shopt -s extglob
    rm -rf native/!(index.node)
    rm -rf node_modules $HOME
    cp -r . $out
    runHook postInstall
  '';

  cargoSha256 = pinData.cargoHash;
}
