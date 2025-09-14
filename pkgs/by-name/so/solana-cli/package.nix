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
  # Taken from https://github.com/solana-labs/solana/blob/master/scripts/cargo-install-all.sh#L84
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
    "solana-log-analyzer"
    "solana-net-shaper"
    "agave-validator"
    "solana-test-validator"
  ]
  ++ [
    # XXX: Ensure `solana-genesis` is built LAST!
    # See https://github.com/solana-labs/solana/issues/5826
    "solana-genesis"
  ],
}:
let
  version = "2.3.8";
  hash = "sha256-CqkedeQk66VXG6lQAIVGd7ci0KPltf2Qq69iErBAQGo=";
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

  cargoHash = "sha256-J7gyR7K1hauV+VrzoNzRrooLuSkjk8U6A3aFn9O2yFY=";

  strictDeps = true;
  cargoBuildFlags = builtins.map (n: "--bin=${n}") solanaPkgs;
  RUSTFLAGS = "-Amismatched_lifetime_syntaxes -Adead_code";
  LIBCLANG_PATH = "${libclang.lib}/lib";

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
  versionCheckProgramArg = "--version";

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

  # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
  # try to build RocksDB from source.
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  # Require this on darwin otherwise the compiler starts rambling about missing
  # cmath functions
  CPPFLAGS = lib.optionals stdenv.hostPlatform.isDarwin "-isystem ${lib.getInclude stdenv.cc.libcxx}/include/c++/v1";
  LDFLAGS = lib.optionals stdenv.hostPlatform.isDarwin "-L${lib.getLib stdenv.cc.libcxx}/lib";

  # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Web-Scale Blockchain for fast, secure, scalable, decentralized apps and marketplaces";
    homepage = "https://solana.com";
    license = licenses.asl20;
    maintainers = with maintainers; [
      netfox
      happysalada
      aikooo7
      JacoMalan1
    ];
    platforms = platforms.unix;
  };

  passthru.updateScript = nix-update-script { };
}
