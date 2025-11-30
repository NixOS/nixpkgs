{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  libiconv,
  useMimalloc ? false,
  doCheck ? true,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-analyzer-unwrapped";
  version = "2025-10-28";

  cargoHash = "sha256-iw+Pgtv5VkCRSa07ap5fjhVZQgo+sfNjp5A4yaHdX1M=";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = version;
    hash = "sha256-rNsxpCKWzVNJ5FR71mpZFSEPxuvZfAQzcVpgfwgajQU=";
  };

  cargoBuildFlags = [
    "--bin"
    "rust-analyzer"
    "--bin"
    "rust-analyzer-proc-macro-srv"
  ];
  cargoTestFlags = [
    "--package"
    "rust-analyzer"
    "--package"
    "proc-macro-srv-cli"
  ];

  # Code format check requires more dependencies but don't really matter for packaging.
  # So just ignore it.
  checkFlags = [ "--skip=tidy::check_code_formatting" ];

  nativeBuildInputs = lib.optional useMimalloc cmake;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  buildFeatures = lib.optional useMimalloc "mimalloc";

  env.CFG_RELEASE = version;

  inherit doCheck;
  preCheck = lib.optionalString doCheck ''
    export RUST_SRC_PATH=${rustPlatform.rustLibSrc}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    # FIXME: Pass overrided `rust-analyzer` once `buildRustPackage` also implements #119942
    # FIXME: test script can't find rust std lib so hover doesn't return expected result
    # https://github.com/NixOS/nixpkgs/pull/354304
    # tests.neovim-lsp = callPackage ./test-neovim-lsp.nix { };
  };

  meta = with lib; {
    description = "Language server for the Rust language";
    homepage = "https://rust-analyzer.github.io";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ oxalica ];
    mainProgram = "rust-analyzer";
  };
}
