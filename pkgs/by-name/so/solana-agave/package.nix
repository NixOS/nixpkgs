{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
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

  # Because crossbeam-epoch in Cargo.lock uses a git rev instead of a locked checksum
  useFetchCargoVendor = true;

  cargoHash = "sha256-PWt5vDDnfnu+9HTVr3hHHxzhpmxZF5T2q1ZMaV7t2Ic=";

  nativeBuildInputs = [ installShellFiles protobuf cmake gnumake clang llvm llvmPackages.bintools openssl.dev pkg-config ];
  buildInputs =
    [ openssl libz rustPlatform.bindgenHook ]
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11
    ++ lib.optionals stdenv.hostPlatform.isLinux [ udev ];

  preFixup = lib.optionalString canRun ''
    ${agave} --generate man > agave.1
    installManPage agave.1

    installShellCompletion --cmd agave \
      --bash <(${agave} --generate complete-bash) \
      --fish <(${agave} --generate complete-fish) \
      --zsh <(${agave} --generate complete-zsh)
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

  # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;
}
