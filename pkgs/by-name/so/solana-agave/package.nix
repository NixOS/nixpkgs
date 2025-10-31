{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  rustfmt,
  installShellFiles,
  pkg-config,
  apple-sdk_11,
  udev,
  openssl,
  libz,
  protobuf,
  cmake,
  gnumake,
  clang,
  llvm,
  llvmPackages,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "solana-agave";
  version = "2.3.12";

  src = fetchFromGitHub {
    owner = "anza-xyz";
    repo = "agave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-25UgiC5jAnlNE8Z7WrQRIviCuFp4zg57ddYA4h0qJ6U=";
  };

  cargoHash = "sha256-x8rEdMn7BpVnfkfnS460oo6In0hloLzDQgBVgFMfaSA=";
  # Because crossbeam-epoch in Cargo.lock uses a git rev instead of a locked checksum
  useFetchCargoVendor = true;

  # For the same reason as discussed in solana-cli derivation (crossbeam softlink), the no_atomic file is missing
  # and either must somehow be rendered unneeded (using an upstream package) or replaced. A cleaner, non-behavior-changing,
  # solution would be to commit the file to the repo fork (replacing the softlink).
  cargoPatches = [
    ./crossbeam-epoch.patch
    ./qualifier_attr-dep.patch
  ];

  nativeBuildInputs = [
    installShellFiles
    protobuf
    cmake
    gnumake
    clang
    llvm
    llvmPackages.bintools
    openssl.dev
    pkg-config
    rustfmt
  ];
  buildInputs =
    [
      openssl
      libz
      rustPlatform.bindgenHook
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  doInstallCheck = false;

  env = {
    # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
    OPENSSL_NO_VENDOR = 1;
  };

  # Disabling tests because:
  #
  # ```
  # running 3 tests
  # test args::tests::test_max_genesis_archive_unpacked_size_constant ... ok
  # test bigtable::tests::test_missing_blocks ... ok
  # error: test failed, to rerun pass `-p agave-ledger-tool --bin agave-ledger-tool`
  #
  # Caused by:
  #   process didn't exit successfully: `/build/source/target/x86_64-unknown-linux-gnu/release/deps/agave_ledger_tool-b8aca978c218ed51` (signal: 4, SIGILL: illegal instruction)
  # ```
  #
  # Almost certainly caused by the ledger-tool test calling `Command::cargo_bin` which assumes a good bit about the current environment.
  doCheck = false;

  meta = {
    description = "Solana Network Validator";
    homepage = "https://github.com/anza-xyz/agave";
    changelog = "https://github.com/anza-xyz/agave/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
    ];
    maintainers = with lib.maintainers; [
      TomMD
    ];
    mainProgram = "agave";
  };
})
