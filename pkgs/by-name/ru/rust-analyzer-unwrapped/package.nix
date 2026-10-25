{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  libiconv,
  useMimalloc ? false,
  doCheck ? true,
  nix-update-script,
  versionCheckHook,
  rust-analyzer,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-analyzer-unwrapped";
  version = "2026-10-19";

  cargoHash = "sha256-hk9RPaaLoNnsnR4WBNV0h/VW7JUohoK7DB0OKmJU8C0=";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = finalAttrs.version;
    hash = "sha256-d1RSuaMORfpT6wVgzvdwuaCFeozUWZKN+1CjnDUBK5c=";
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

  env.CFG_RELEASE = finalAttrs.version;

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

    tests.neovim-lsp = callPackage ./test-neovim-lsp.nix {
      rust-analyzer = rust-analyzer.override {
        rust-analyzer-unwrapped = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Language server for the Rust language";
    homepage = "https://rust-analyzer.github.io";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      diogotcorreia
      oxalica
    ];
    mainProgram = "rust-analyzer";
  };
})
