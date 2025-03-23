{
  stdenv,
  fetchFromGitHub,
  lib,
  rustPlatform,
  darwin,
  udev,
  protobuf,
  libcxx,
  rocksdb_8_3,
  installShellFiles,
  pkg-config,
  openssl,
  nix-update-script,
  versionCheckHook,
  # Taken from https://github.com/solana-labs/solana/blob/master/scripts/cargo-install-all.sh#L84
  solanaPkgs ?
    [
      "cargo-build-bpf"
      "cargo-test-bpf"
      "cargo-build-sbf"
      "cargo-test-sbf"
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
      "solana-test-validator"
    ]
    ++ [
      # XXX: Ensure `solana-genesis` is built LAST!
      # See https://github.com/solana-labs/solana/issues/5826
      "solana-genesis"
    ],
}:
let
  version = "1.18.26";
  hash = "sha256-sJ0Zn5GMi64/S8zqomL/dYRVW8SOQWsP+bpcdatJC0A=";
  rocksdb = rocksdb_8_3;

  inherit (darwin.apple_sdk_11_0) Libsystem;
  inherit (darwin.apple_sdk_11_0.frameworks)
    System
    IOKit
    AppKit
    Security
    ;
in
rustPlatform.buildRustPackage rec {
  pname = "solana-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "solana";
    tag = "v${version}";
    inherit hash;
  };

  # The `crossbeam-epoch@0.9.5` crate used by the solana crates is their own fork,
  # which exists due to performance-related reasons.
  # The `solana-cli` build fails because this forked `crossbeam-epoch` crate contains a
  # symlink that points outside of the crate into the root of the repository.
  # This characteristic already existed in upstream `crossbeam-epoch@0.9.5`.
  #
  # As `buildRustPackage` vendors the dependencies of the `solana-cli` during the `buildPhase`,
  # which occurs after the `patchPhase`, this `crossbeam-epoch` is not patchable in this build.
  # The remaining solution is to make use of `cargoPatches` to remove the fork and bump to `crossbeam-epoch@0.9.16`,
  # which is the first version that removed the `build.rs`.
  cargoPatches = [ ./crossbeam-epoch.patch ];

  cargoHash = "sha256-adzcLrOiUUYhz57gme/hEmD4E3kVcKCp0/jSoavZfjw=";
  useFetchCargoVendor = true;

  strictDeps = true;
  cargoBuildFlags = builtins.map (n: "--bin=${n}") solanaPkgs;

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
  buildInputs =
    [
      openssl
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libcxx
      IOKit
      Security
      AppKit
      System
      Libsystem
    ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/solana";
  versionCheckProgramArg = "--version";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd solana \
      --bash <($out/bin/solana completion --shell bash) \
      --fish <($out/bin/solana completion --shell fish)

    mkdir -p $out/bin/sdk/bpf
    cp -a ./sdk/bpf/* $out/bin/sdk/bpf/
    mkdir -p $out/bin/sdk/sbf
    cp -a ./sdk/sbf/* $out/bin/sdk/sbf
    mkdir -p $out/bin/deps
    find . -name libsolana_program.dylib -exec cp {} $out/bin/deps \;
    find . -name libsolana_program.rlib -exec cp {} $out/bin/deps \;
  '';

  # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
  # try to build RocksDB from source.
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  # Require this on darwin otherwise the compiler starts rambling about missing
  # cmath functions
  CPPFLAGS = lib.optionals stdenv.hostPlatform.isDarwin "-isystem ${lib.getDev libcxx}/include/c++/v1";
  LDFLAGS = lib.optionals stdenv.hostPlatform.isDarwin "-L${lib.getLib libcxx}/lib";

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
    ];
    platforms = platforms.unix;
  };

  passthru.updateScript = nix-update-script { };
}
