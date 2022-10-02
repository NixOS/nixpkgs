{ lib, stdenv, fetchFromGitHub, nodejs, python3, callPackage, removeReferencesTo
, fixup_yarn_lock, yarn, pkg-config, libsecret, xcbuild, Security, AppKit, fetchYarnDeps }:

let
  pinData = lib.importJSON ./pin.json;

in stdenv.mkDerivation rec {
  pname = "keytar";
  inherit (pinData) version;

  src = fetchFromGitHub {
    owner = "atom";
    repo = "node-keytar";
    rev = "v${version}";
    sha256 = pinData.srcHash;
  };

  nativeBuildInputs = [ nodejs python3 yarn pkg-config ]
    ++ lib.optional  stdenv.isDarwin xcbuild;
  buildInputs = lib.optionals (!stdenv.isDarwin) [ libsecret ]
    ++ lib.optionals stdenv.isDarwin [ Security AppKit ];

  npm_config_nodedir = nodejs;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    sha256 = pinData.yarnHash;
  };

  buildPhase = ''
    runHook preBuild
    cp ${./yarn.lock} ./yarn.lock
    chmod u+w . ./yarn.lock
    export HOME=$PWD/tmp
    mkdir -p $HOME
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    node_modules/.bin/node-gyp rebuild
    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall
    shopt -s extglob
    rm -rf node_modules
    rm -rf $HOME
    mkdir -p $out
    cp -r ./!(build) $out
    install -D -t $out/build/Release build/Release/keytar.node
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $out/build/Release/keytar.node
    runHook postInstall
  '';

  disallowedReferences = [ stdenv.cc.cc ];
}
