# largely inspired from https://github.com/saber-hq/saber-overlay/blob/master/packages/solana/solana.nix

{ stdenv
, fetchFromGitHub
, lib
, rustPlatform
, IOKit
, Security
, AppKit
, pkg-config
, udev
, zlib
, protobuf
, clang
, llvm
, openssl
, libclang
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
    "solana-sys-tuner"
    "solana-validator"
    "cargo-build-bpf"
    "cargo-test-bpf"
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
  sha256 = pinData.sha256;
  cargoSha256 = pinData.cargoSha256;
in
rustPlatform.buildRustPackage rec {
  pname = "solana-validator";
  inherit version;

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "solana";
    rev = "v${version}";
    inherit sha256;
  };

  # partly inspired by https://github.com/obsidiansystems/solana-bridges/blob/develop/default.nix#L29
  inherit cargoSha256;
  verifyCargoDeps = true;

  cargoBuildFlags = builtins.map (n: "--bin=${n}") solanaPkgs;

  # weird errors. see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
  # LLVM_CONFIG_PATH = "${llvm}/bin/llvm-config";

  nativeBuildInputs = [ pkg-config protobuf rustfmt perl rustPlatform.bindgenHook ];
  buildInputs =
    [ openssl zlib libclang hidapi ] ++ (lib.optionals stdenv.isLinux [ udev ]);
  strictDeps = true;

  doCheck = false;

  meta = with lib; {
    description = "Web-Scale Blockchain for fast, secure, scalable, decentralized apps and marketplaces. ";
    homepage = "https://solana.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ adjacentresearch ];
    platforms = platforms.unix;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
  };
  passthru.updateScript = ./update.sh;
}
