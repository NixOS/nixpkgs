{ fetchFromGitHub
, lib
, protobuf
, rocksdb
, rustPlatform
, stdenv
, Security
, SystemConfiguration
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot";
    rev = "v${version}";
    hash = "sha256-izm0rpLzwlhpp3dciQ1zj1boWxhgGnNMG5ceZoZQGEE=";

    # the build process of polkadot requires a .git folder in order to determine
    # the git commit hash that is being built and add it to the version string.
    # since having a .git folder introduces reproducibility issues to the nix
    # build, we check the git commit hash after fetching the source and save it
    # into a .git_commit file, and then delete the .git folder. we can then use
    # this file to populate an environment variable with the commit hash, which
    # is picked up by polkadot's build process.
    leaveDotGit = true;
    postFetch = ''
      ( cd $out; git rev-parse --short HEAD > .git_commit )
      rm -rf $out/.git
    '';
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "binary-merkle-tree-4.0.0-dev" = "sha256-J09SHQVOLGStMGONdreI5QZlk+uNNKzWRZpGiNJ+lrk=";
      "sub-tokens-0.1.0" = "sha256-GvhgZhOIX39zF+TbQWtTCgahDec4lQjH+NqamLFLUxM=";
    };
  };

  # NOTE: the build process currently tries to read some files to generate
  # documentation from hardcoded paths that aren't compatible with the cargo
  # vendoring strategy, so we need to manually put them in their expected place.
  # this should be fixed with the next polkadot release that includes
  # https://github.com/paritytech/substrate/pull/14570.
  postPatch = ''
    FAST_UNSTAKE_DIR=$PWD/../cargo-vendor-dir/pallet-fast-unstake-4.0.0-dev
    FAST_UNSTAKE_DOCIFY_DIR=$FAST_UNSTAKE_DIR/frame/fast-unstake

    mkdir -p $FAST_UNSTAKE_DOCIFY_DIR
    cp -r $FAST_UNSTAKE_DIR/src $FAST_UNSTAKE_DOCIFY_DIR
  '';

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  preBuild = ''
    export SUBSTRATE_CLI_GIT_COMMIT_HASH=$(cat .git_commit)
    rm .git_commit
  '';

  PROTOC = "${protobuf}/bin/protoc";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  # NOTE: We don't build the WASM runtimes since this would require a more
  # complicated rust environment setup and this is only needed for developer
  # environments. The resulting binary is useful for end-users of live networks
  # since those just use the WASM blob from the network chainspec.
  SKIP_WASM_BUILD = 1;

  # We can't run the test suite since we didn't compile the WASM runtimes.
  doCheck = false;

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akru andresilva asymmetric FlorianFranzen RaghavSood ];
    platforms = platforms.unix;
  };
}
