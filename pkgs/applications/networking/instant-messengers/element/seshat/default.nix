{ lib, stdenv, rustPlatform, fetchFromGitHub, callPackage, sqlcipher, nodejs-14_x, python3, yarn, fixup_yarn_lock, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "seshat-node";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "seshat";
    rev = version;
    sha256 = "0zigrz59mhih9asmbbh38z2fg0sii2342q6q0500qil2a0rssai7";
  };

  sourceRoot = "source/seshat-node/native";

  nativeBuildInputs = [ nodejs-14_x python3 yarn ];
  buildInputs = [ sqlcipher ] ++ lib.optional stdenv.isDarwin CoreServices;

  npm_config_nodedir = nodejs-14_x;

  yarnOfflineCache = (callPackage ./yarn.nix {}).offline_cache;

  buildPhase = ''
    cd ..
    chmod u+w . ./yarn.lock
    export HOME=$PWD/tmp
    mkdir -p $HOME
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    node_modules/.bin/neon build --release
  '';

  doCheck = false;

  installPhase = ''
    shopt -s extglob
    rm -rf native/!(index.node)
    rm -rf node_modules
    rm -rf $HOME
    cp -r . $out
  '';

  cargoSha256 = "0habjf85mzqxwf8k15msm4cavd7ldq4zpxddkwd4inl2lkvlffqj";
}
