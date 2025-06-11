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
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "Magic-JD";
    repo = "is-fast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wzpd8yA3IpCN3sye1Fk3CUkCihEP6trqPI+oskULS7c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+v1cxH1NKF1tjyc7Bqpd77q6Le8CqvtQ5p0H2ICqc1I=";

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
