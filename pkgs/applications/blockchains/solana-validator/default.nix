# largely inspired from https://github.com/saber-hq/saber-overlay/blob/master/packages/solana/solana.nix

{ stdenv
, fetchFromGitHub
, lib
, rustPlatform
, pkg-config
, darwin
, udev
, zlib
, protobuf
, openssl
, libclang
, libcxx
, rocksdb_8_3
, rustfmt
, perl
, hidapi
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
    "cargo-build-bpf"
    "cargo-test-bpf"
    "cargo-build-sbf"
    "cargo-test-sbf"
    "solana-dos"
    "solana-install-init"
    "solana-stake-accounts"
    "solana-test-validator"
    "solana-tokens"
    "solana-watchtower"
  ] ++ [
    # XXX: Ensure `solana-genesis` is built LAST!
    # See https://github.com/solana-labs/solana/issues/5826
    "solana-genesis"
  ]
}:
let
  pinData = lib.importJSON ./pin.json;
  version = pinData.version;
  hash = pinData.hash;
  rocksdb = rocksdb_8_3;
  inherit (darwin.apple_sdk_11_0) Libsystem;
  inherit (darwin.apple_sdk_11_0.frameworks) System IOKit AppKit Security;
in
rustPlatform.buildRustPackage rec {
  pname = "solana-validator";
  inherit version;

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "solana";
    rev = "v${version}";
    inherit hash;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "aes-gcm-siv-0.10.3" = "sha256-N1ppxvew4B50JQWsC3xzP0X4jgyXZ5aOQ0oJMmArjW8=";
      "crossbeam-epoch-0.9.5" = "sha256-Jf0RarsgJiXiZ+ddy0vp4jQ59J9m0k3sgXhWhCdhgws=";
      "curve25519-dalek-3.2.1" = "sha256-FuVNFuGCyHXqKqg+sn3hocZf1KMCI092Ohk7cvLPNjQ=";
      "tokio-1.29.1" = "sha256-Z/kewMCqkPVTXdoBcSaFKG5GSQAdkdpj3mAzLLCjjGk=";
    };
  };

  cargoBuildFlags = builtins.map (n: "--bin=${n}") solanaPkgs;

  # weird errors. see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
  # LLVM_CONFIG_PATH = "${llvm}/bin/llvm-config";

  nativeBuildInputs = [ pkg-config protobuf rustfmt perl rustPlatform.bindgenHook ];
  buildInputs =
    [ openssl zlib libclang hidapi ] ++ (lib.optionals stdenv.isLinux [ udev ])
    ++ lib.optionals stdenv.isDarwin [ Security System Libsystem libcxx ];
  strictDeps = true;

  doCheck = false;

  postInstall = ''
    mkdir -p $out/bin/sdk/sbf
    cp -a ./sdk/sbf/* $out/bin/sdk/sbf/
    mkdir -p $out/bin/deps
    find . -name libsolana_program.dylib -exec cp {} $out/bin/deps/ \;
    find . -name libsolana_program.rlib -exec cp {} $out/bin/deps/ \;
  '';

  env = {
    # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
    # try to build RocksDB from source.
    ROCKSDB_LIB_DIR = "${lib.getLib rocksdb}/lib";

    # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
    OPENSSL_NO_VENDOR = "1";
  } // lib.optionalAttrs stdenv.isDarwin {
    # Require this on darwin otherwise the compiler starts rambling about missing
    # cmath functions
    CPPFLAGS = "-isystem ${lib.getDev libcxx}/include/c++/v1";
    LDFLAGS = "-L${lib.getLib libcxx}/lib";
  };

  meta = with lib; {
    description = "Web-Scale Blockchain for fast, secure, scalable, decentralized apps and marketplaces.";
    homepage = "https://solana.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ adjacentresearch ];
    platforms = platforms.unix;
  };
  passthru.updateScript = ./update.sh;
}
