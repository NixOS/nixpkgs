{ fetchFromGitHub
, lib
, protobuf
, rocksdb
, rustPlatform
, rustc-wasm32
, stdenv
, Security
, SystemConfiguration
}:
rustPlatform.buildRustPackage rec {
  pname = "polkadot";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "polkadot-sdk";
    rev = "polkadot-v${version}";
    hash = "sha256-B9egLeXZ6xGJ5g5+A9KXYGdesN5Gkrr2qQJe/7hwB5I=";

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

  preBuild = ''
    export SUBSTRATE_CLI_GIT_COMMIT_HASH=$(< .git_commit)
    rm .git_commit
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ark-secret-scalar-0.0.2" = "sha256-Nbf77KSsAjDKiFIP5kgzl23fRB+68x1EirNuZlS7jeM=";
      "common-0.1.0" = "sha256-3OKBPpk0exdlV0N9rJRVIncSrkwdI8bkYL2QNsJl+sY=";
      "fflonk-0.1.0" = "sha256-MNvlePHQdY8DiOq6w7Hc1pgn7G58GDTeghCKHJdUy7E=";
      "sub-tokens-0.1.0" = "sha256-GvhgZhOIX39zF+TbQWtTCgahDec4lQjH+NqamLFLUxM=";
    };
  };

  cargoBuildFlags = [ "-p" "polkadot" ];

  # NOTE: tests currently fail to compile due to an issue with cargo-auditable
  # and resolution of features flags, potentially related to this:
  # https://github.com/rust-secure-code/cargo-auditable/issues/66
  doCheck = false;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    rustc-wasm32
    rustc-wasm32.llvmPackages.lld
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  # NOTE: we need to force lld otherwise rust-lld is not found for wasm32 target
  CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER = "lld";
  PROTOC = "${protobuf}/bin/protoc";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  meta = with lib; {
    description = "Polkadot Node Implementation";
    homepage = "https://polkadot.network";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akru andresilva asymmetric FlorianFranzen RaghavSood ];
    platforms = platforms.unix;
  };
}
