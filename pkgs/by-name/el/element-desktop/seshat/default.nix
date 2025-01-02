{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  sqlcipher,
  nodejs,
  python3,
  yarn,
  fixup-yarn-lock,
  fetchYarnDeps,
  removeReferencesTo,
}:

let
  pinData = lib.importJSON ./pin.json;

in
rustPlatform.buildRustPackage rec {
  pname = "seshat-node";
  inherit (pinData) version cargoHash;

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "seshat";
    rev = version;
    hash = pinData.srcHash;
  };

  sourceRoot = "${src.name}/seshat-node/native";

  nativeBuildInputs = [
    nodejs
    python3
    yarn
    fixup-yarn-lock
  ];
  buildInputs = [ sqlcipher ];

  npm_config_nodedir = nodejs;

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
    yarn config --offline set yarn-offline-mirror $yarnOfflineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    node_modules/.bin/neon build --release -- --target ${stdenv.hostPlatform.rust.rustcTarget} -Z unstable-options --out-dir target/release
    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall
    shopt -s extglob
    rm -rf native/!(index.node)
    rm -rf node_modules $HOME
    cp -r . $out
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $out/native/index.node
    runHook postInstall
  '';

  disallowedReferences = [ stdenv.cc.cc ];
}
