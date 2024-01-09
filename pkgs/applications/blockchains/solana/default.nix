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
    "cargo-build-bpf"
    "cargo-build-sbf"
    "cargo-test-bpf"
    "cargo-test-sbf"
    "rbpf-cli"
    "solana-bench-tps"
    "solana-dos"
    "solana-faucet"
    "solana-gossip"
    "solana-install-init"
    "solana-install"
    "solana-keygen"
    "solana-ledger-tool"
    "solana-log-analyzer"
    "solana-net-shaper"
    "solana-stake-accounts"
    "solana-test-validator"
    "solana-tokens"
    "solana-validator"
    "solana-watchtower"
    "solana"

] ++ [
    # XXX: Ensure `solana-genesis` is built LAST!
    # See https://github.com/solana-labs/solana/issues/5826
    "solana-genesis"
  ]
}:
let
  version = "1.17.3";
  sha256 = "sha256-NUkkLzLNh8P7PFh/SVtd9JM18w3egDaaK80urGw1SSs=";
  cargoSha256 = "sha256-7t8Quh6T2MzJWEM5Y50CgCyFfx2ZJRAdCpZyyYvJrt4=";

  inherit (darwin.apple_sdk_11_0) Libsystem;
  inherit (darwin.apple_sdk_11_0.frameworks) System IOKit AppKit Security;
in
rustPlatform.buildRustPackage rec {
  pname = "solana-cli";
  inherit version cargoSha256;

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "solana";
    rev = "v${version}";
    inherit sha256;
  };

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
    maintainers = with maintainers; [ netfox happysalada ];
    platforms = platforms.unix;
  };

  passthru.updateScript = nix-update-script { };
}
