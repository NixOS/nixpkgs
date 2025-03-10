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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "Magic-JD";
    repo = "is-fast";
    tag = "v${finalAttrs.version}";
    hash = "sha256-exC9xD0scCa1jYomBCewaLv2kzoxSjHhc75EhEERPR8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-r1neLuUkWVKl7Qc4FNqW1jzX/HHyVJPEqgZV/GYkGRU=";

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
