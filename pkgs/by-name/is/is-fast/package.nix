{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  openssl,
  oniguruma,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "is-fast";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "Magic-JD";
    repo = "is-fast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6gMXYOgPlVaN5UM+U55Jtbva8/i9BFghBaqboqTwdPg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-EQdO4K3AQL0BR9hnoViiCMhDbcg2db8Ho2Ilvysr1dU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    oniguruma
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

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
