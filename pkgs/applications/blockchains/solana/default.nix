{ lib
, stdenv
, clang
, fetchFromGitHub
, llvm
, llvmPackages
, openssl
, pkg-config
, rustPlatform
, udev
, zlib
, rocksdb
}:

rustPlatform.buildRustPackage rec {
  pname = "solana";
  # Please stick to mainnet releases here.
  version = "1.5.19";

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "04d2rz7hbb57w8zz0bcgkwggx2pz45pgad6imz9qsnqidwv4zc1v";
  };

  cargoSha256 = "0j6j9ivzb430pk154nnn9bm6gw9rh4frk4gvq6iv0nmlnvgqfg42";

  nativeBuildInputs = [
    pkg-config
    llvmPackages.clang
  ];

  buildInputs = [
    llvm
    llvmPackages.libclang
    openssl
    udev
    zlib
    rocksdb
  ];

  preBuild = ''
    export LLVM_CONFIG_PATH="${llvm}/bin/llvm-config";
    export LIBCLANG_PATH="${llvmPackages.libclang}/lib";

    # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
    # try to build RocksDB from source.
    export ROCKSDB_INCLUDE_DIR="${rocksdb}/include";
    export ROCKSDB_LIB_DIR="${rocksdb}/lib";
  '';

  patches = [
    # https://github.com/solana-labs/solana/issues/16823
    ./0001-Make-test_hash_stored_account-pass-in-release-mode.patch
  ];

  # The metrics::counter tests depend on the RUST_LOG environment variable, and
  # need it to be unset or at least INFO. buildRustPackage sets it to "" if we
  # don't specify it, which makes these tests fail.
  # This can be removed after https://github.com/solana-labs/solana/pull/16710
  # is merged and released.
  logLevel = "INFO";

  # Some tests are flaky or broken, disable them.
  postPatch = ''
    function disable() {
      sed --regexp-extended --in-place "s/(pub )?fn $1\(\)/#[ignore] fn $1()/g" $2
    }

    # https://github.com/solana-labs/solana/issues/16680
    disable test_push_votes_with_tower core/src/cluster_info.rs

    # https://github.com/solana-labs/solana/issues/16684
    disable test_banking_stage_entryfication core/src/banking_stage.rs

    # https://github.com/solana-labs/solana/issues/16904
    disable test_new_from_file_crafted_executable runtime/src/append_vec.rs

    # https://github.com/solana-labs/solana/issues/16963
    disable test_recv_mmsg_batch_size streamer/tests/recvmmsg.rs

    # https://github.com/solana-labs/solana/issues/16970
    disable test_rpc_subscriptions core/tests/rpc.rs
    disable test_rpc_slot_updates core/tests/rpc.rs

    # These tests do pass, but they take a long time (~half an hour) to run,
    # so skip them.
    rm local-cluster/tests/local_cluster.rs
  '';

  meta = with lib; {
    description = "Web-scale blockchain for fast, secure, scalable, decentralized apps and marketplaces";
    homepage = "https://solana.com/";
    changelog = "https://github.com/solana-labs/solana/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
