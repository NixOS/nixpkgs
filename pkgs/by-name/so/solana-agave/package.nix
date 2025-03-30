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

let
  canRun = stdenv.hostPlatform.emulatorAvailable buildPackages;
  agave = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/agave";
in
rustPlatform.buildRustPackage rec {
  pname = "solana-agave";
  version = "2.1.16";

  src = fetchFromGitHub {
    owner = "anza-xyz";
    repo = "agave";
    rev = "v${version}";
    hash = "sha256-ysH4krWr0U6YnuAlq0EmqCoTpMrrEV40wUb5daOAVS8=";
  };

  cargoHash = "sha256-Kjh1Tvze7mDomLFt3bN+ZbTtuKr12Mbo1hDjTa9hFKU=";
  # Because crossbeam-epoch in Cargo.lock uses a git rev instead of a locked checksum
  useFetchCargoVendor = true;

  nativeBuildInputs = [ installShellFiles protobuf cmake gnumake clang llvm llvmPackages.bintools openssl.dev pkg-config rustfmt ];
  buildInputs =
    [ openssl libz rustPlatform.bindgenHook ]
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11
    ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  preFixup = lib.optionalString canRun ''
    # ex as done for rg:
    # ${agave} --generate man > agave.1
    # installManPage agave.1

    # installShellCompletion --cmd agave \
    #   --bash <(${agave} --generate complete-bash) \
    #   --fish <(${agave} --generate complete-fish) \
    #   --zsh <(${agave} --generate complete-zsh)
  '';

  doInstallCheck = false;

  meta = with lib; {
    description = "Solana Network Validator";
    homepage = "https://github.com/anza-xyz/agave";
    changelog = "https://github.com/anza-xyz/agave/releases/tag/${version}";
    license = with licenses; [
      asl20
    ];
    maintainers = with maintainers; [
        TomMD
    ];
    mainProgram = "agave";
  };

  # For the same reason as discussed in solana-cli derivation (crossbeam softlink), the no_atomic file is missing
  # and either must somehow be rendered unneeded (using an upstream package) or replaced. A cleaner, non-behavior-changing,
  # solution would be to commit the file to the repo fork (replacing the softlink).
  cargoPatches = [ ./crossbeam-epoch.patch ];

  # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;
}
