{
  stdenv,
  fetchFromGitHub,
  lib,
  rustPlatform,
  udev,
  protobuf,
  installShellFiles,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
  clang,
  libclang,
  rocksdb,
  # Taken from https://github.com/anza-xyz/agave/blob/master/scripts/cargo-install-all.sh#L84
  solanaPkgs ? [
    "cargo-build-sbf"
    "cargo-test-sbf"
    "solana"
    "solana-bench-tps"
    "solana-faucet"
    "solana-gossip"
    "agave-install"
    "solana-keygen"
    "agave-ledger-tool"
    "solana-dos"
    "solana-net-shaper"
    "agave-validator"
    "solana-test-validator"
    "agave-watchtower"
  ]
  ++ [
    # XXX: Ensure `solana-genesis` is built LAST!
    # See https://github.com/solana-labs/solana/issues/5826
    "solana-genesis"
  ],
}:
let
  version = "3.0.12";
  hash = "sha256-Zubu7cTSJrJFSuguCo3msdas/QshFpo1+T6DVQyqrhY=";
in
rustPlatform.buildRustPackage rec {
  pname = "solana-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "anza-xyz";
    repo = "agave";
    tag = "v${version}";
    inherit hash;
  };

  cargoHash = "sha256-qnZbFkyzE2hdy/ynZQZmCs5kCeTUMci9f/pVKID/mRQ=";

  strictDeps = true;
  cargoBuildFlags = map (n: "--bin=${n}") solanaPkgs;

  env = {
    RUSTFLAGS = "-Amismatched_lifetime_syntaxes -Adead_code -Aunused_parens";
    LIBCLANG_PATH = "${libclang.lib}/lib";

    # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
    # try to build RocksDB from source.
    ROCKSDB_LIB_DIR = "${rocksdb}/lib";

    # Require this on darwin otherwise the compiler starts rambling about missing
    # cmath functions
    CPPFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-isystem ${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";
    LDFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-L${lib.getLib stdenv.cc.libcxx}/lib";

    # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
    OPENSSL_NO_VENDOR = 1;
  };

  # Even tho the tests work, a shit ton of them try to connect to a local RPC
  # or access internet in other ways, eventually failing due to Nix sandbox.
  # Maybe we could restrict the check to the tests that don't require an RPC,
  # but judging by the quantity of tests, that seems like a lengthty work and
  # I'm not in the mood ((ΦωΦ))
  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
    protobuf
    pkg-config
  ];
  buildInputs = [
    openssl
    clang
    libclang
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/solana";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd solana \
      --bash <($out/bin/solana completion --shell bash) \
      --fish <($out/bin/solana completion --shell fish)

    mkdir -p $out/bin/platform-tools-sdk
    cp -r ./platform-tools-sdk/sbf $out/bin/platform-tools-sdk

    mkdir -p $out/bin/deps
    find . -name libsolana_program.dylib -exec cp {} $out/bin/deps \;
    find . -name libsolana_program.rlib -exec cp {} $out/bin/deps \;
  '';

  meta = {
    description = "Web-Scale Blockchain for fast, secure, scalable, decentralized apps and marketplaces";
    homepage = "https://solana.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      netfox
      happysalada
      aikooo7
      JacoMalan1
    ];
    platforms = lib.platforms.unix;
  };

  passthru.updateScript = nix-update-script { };
}
