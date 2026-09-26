{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rucola";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "Linus-Mussmaecher";
    repo = "rucola";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dE2XlO+CwC78GblNoyv7oA5d/GezzuiuOwcQjsm7Pns=";
  };

  cargoHash = "sha256-yhBY/6NLn1aIRZLLpHrEsMo/yzSnKzsvrIiJFCRcYMc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    openssl
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  # Fails on Darwin
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=io::file_tracker::tests::test_watcher_rename"
  ];

  meta = {
    description = "Terminal-based markdown note manager";
    homepage = "https://github.com/Linus-Mussmaecher/rucola";
    changelog = "https://github.com/Linus-Mussmaecher/rucola/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ donovanglover ];
    mainProgram = "rucola";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
