{
  lib,
  rustPlatform,
  stdenvNoCC,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libgit2,
  libssh2,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gittype";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "gittype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pzJWXVCGUn85OCHMRlMY5ufrGyJyuhhkYLUk4e01Ri0=";
  };

  cargoHash = "sha256-E1LKaiTClHmrF7zhGEj1rfELKryIiyVKIf/8Rozm1RQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    libgit2
    libssh2
  ];

  env = {
    OPENSSL_NO_VENDOR = 1;
    LIBGIT2_NO_VENDOR = 1;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
  };

  nativeCheckInputs = [ gitMinimal ];

  checkFlags = [
    "--skip=unit::domain::services::challenge_generator::challenge_generator_tests::"
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    "--skip=unit::domain::services::scoring::tracker::stage::test_pause_resume"
    "--skip=unit::domain::services::scoring::calculator::stage::test_calculate_with_pauses"
    "--skip=unit::domain::services::scoring::calculator::stage::test_pause_resume"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI code-typing game that turns your source code into typing challenges";
    homepage = "https://github.com/unhappychoice/gittype";
    changelog = "https://github.com/unhappychoice/gittype/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "gittype";
    # corrupted size vs. prev_size
    # error: test failed, to rerun pass `--test mod`
    broken = stdenvNoCC.hostPlatform.isAarch64 && stdenvNoCC.hostPlatform.isLinux;
  };
})
