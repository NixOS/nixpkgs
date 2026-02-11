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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-analyzer-unwrapped";
  version = "2026-02-09";

  cargoHash = "sha256-MAEzZDXY7W6ZlWWCK4Rx8hQtWijTt3giYxaJiaPAw5M=";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "rust-analyzer";
    rev = finalAttrs.version;
    hash = "sha256-S6qG5sNG76JitdRRY0dyEq9+n+4TJuqKrFrtTpripAo=";
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
    # FIXME: Pass overrided `rust-analyzer` once `buildRustPackage` also implements #119942
    # FIXME: test script can't find rust std lib so hover doesn't return expected result
    # https://github.com/NixOS/nixpkgs/pull/354304
    # tests.neovim-lsp = callPackage ./test-neovim-lsp.nix { };
  };

  meta = {
    description = "Language server for the Rust language";
    homepage = "https://rust-analyzer.github.io";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ oxalica ];
    mainProgram = "rust-analyzer";
  };
})
