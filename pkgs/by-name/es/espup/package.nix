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
  testers,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "espup";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "esp-rs";
    repo = "espup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-blEjUFBzkwplwZgTAtI84MCHvxujNF1WsPJJezRNjxQ=";
  };

  cargoHash = "sha256-Y6Y+62lJ3k6GMkU82CDkTt1Prd3UrtBKqA5Spctochw=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    bzip2
    openssl
    xz
    zstd
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

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

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Tool for installing and maintaining Espressif Rust ecosystem";
    homepage = "https://github.com/esp-rs/espup/";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      knightpp
      beeb
    ];
    mainProgram = "espup";
  };
})
