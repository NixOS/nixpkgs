{ stdenv
, fetchFromGitHub
, lib
, rustPlatform
, darwin
, udev
, protobuf
, libcxx
, rocksdb
, pkg-config
, openssl
, nix-update-script
# Taken from https://github.com/solana-labs/solana/blob/master/scripts/cargo-install-all.sh#L84
, solanaPkgs ? [
    "solana"
    "solana-bench-tps"
    "solana-faucet"
    "solana-gossip"
    "solana-install"
    "solana-keygen"
    "solana-ledger-tool"
    "solana-log-analyzer"
    "solana-net-shaper"
    "solana-validator"
] ++ [
    # XXX: Ensure `solana-genesis` is built LAST!
    # See https://github.com/solana-labs/solana/issues/5826
    "solana-genesis"
  ]
}:
let
  version = "1.16.27";
  sha256 = "sha256-xd0FCSlpPJDVWOlt9rIlnSbjksmvlXJWHkvlZONd2dM=";

  inherit (darwin.apple_sdk_11_0) Libsystem;
  inherit (darwin.apple_sdk_11_0.frameworks) System IOKit AppKit Security;
in
rustPlatform.buildRustPackage rec {
  pname = "solana-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "solana";
    rev = "v${version}";
    inherit sha256;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "crossbeam-epoch-0.9.5" = "sha256-Jf0RarsgJiXiZ+ddy0vp4jQ59J9m0k3sgXhWhCdhgws=";
      "ntapi-0.3.7" = "sha256-G6ZCsa3GWiI/FeGKiK9TWkmTxen7nwpXvm5FtjNtjWU=";
    };
  };

  patches = [
    # Fix: https://github.com/solana-labs/solana/issues/34203
    # From https://github.com/Homebrew/homebrew-core/pull/156930/files#diff-f27c55b86df31cd4935c956efee1be743eae0958e3850f3f9891d51bfea50b1cR76
    ./account-info.patch
  ];

  strictDeps = true;
  cargoBuildFlags = builtins.map (n: "--bin=${n}") solanaPkgs;

  # Even tho the tests work, a shit ton of them try to connect to a local RPC
  # or access internet in other ways, eventually failing due to Nix sandbox.
  # Maybe we could restrict the check to the tests that don't require an RPC,
  # but judging by the quantity of tests, that seems like a lengthty work and
  # I'm not in the mood ((ΦωΦ))
  doCheck = false;

  nativeBuildInputs = [ protobuf pkg-config ];
  buildInputs = [ openssl rustPlatform.bindgenHook ]
                ++ lib.optionals stdenv.isLinux [ udev ]
                ++ lib.optionals stdenv.isDarwin [
                  libcxx
                  IOKit
                  Security
                  AppKit
                  System
                  Libsystem ];

  postInstall = ''
    mkdir -p $out/bin/sdk/bpf
    cp -a ./sdk/bpf/* $out/bin/sdk/bpf/
  '';

  # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
  # try to build RocksDB from source.
  ROCKSDB_LIB_DIR="${rocksdb}/lib";

  # Require this on darwin otherwise the compiler starts rambling about missing
  # cmath functions
  CPPFLAGS=lib.optionals stdenv.isDarwin "-isystem ${lib.getDev libcxx}/include/c++/v1";
  LDFLAGS=lib.optionals stdenv.isDarwin "-L${lib.getLib libcxx}/lib";

  # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Web-Scale Blockchain for fast, secure, scalable, decentralized apps and marketplaces. ";
    homepage = "https://solana.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ netfox happysalada aikooo7 ];
    platforms = platforms.unix;
  };

  passthru.updateScript = nix-update-script { };
}
