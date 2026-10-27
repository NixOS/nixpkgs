{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  oniguruma,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "is-fast";
  version = "0.17.7";

  src = fetchFromGitHub {
    owner = "Magic-JD";
    repo = "is-fast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9uq/MEa3t44pKBv8GaHDA8cZk8pI4ruFebVUWrPUxgc=";
  };

  cargoHash = "sha256-RMGrBLgFvJ8YBblWsPC41Eva7wPRM400jAM137waWUI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ oniguruma ];

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Error creating config directory: Operation not permitted (os error 1)
    # Using writableTmpDirAsHomeHomeHook is not working
    "--skip=generate_config::tests::test_run_creates_config_file"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Check the internet as fast as possible";
    homepage = "https://github.com/Magic-JD/is-fast";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "is-fast";
  };
})
