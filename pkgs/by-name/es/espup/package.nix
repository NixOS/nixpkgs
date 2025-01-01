{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  bzip2,
  openssl,
  xz,
  zstd,
  stdenv,
  darwin,
  testers,
  espup,
}:

rustPlatform.buildRustPackage rec {
  pname = "espup";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espup";
    rev = "v${version}";
    hash = "sha256-okB8K0ly3MvnkVve41eT0SNr5dPn5E5QXewqLHGL/Tc=";
  };

  cargoHash = "sha256-n2tLG3logtc73Ut/R1UGuLSm7MpZ4Bxp/08SOhGL+80=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    [
      bzip2
      openssl
      xz
      zstd
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # makes network calls
    "--skip=toolchain::rust::tests::test_xtensa_rust_parse_version"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd espup \
      --bash <($out/bin/espup completions bash) \
      --fish <($out/bin/espup completions fish) \
      --zsh <($out/bin/espup completions zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = espup;
  };

  meta = with lib; {
    description = "Tool for installing and maintaining Espressif Rust ecosystem";
    homepage = "https://github.com/esp-rs/espup/";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      knightpp
      beeb
    ];
    mainProgram = "espup";
  };
}
