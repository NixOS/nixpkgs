{
  lib,
  rustPlatform,
  stdenvNoCC,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libgit2,
  libssh2,
  cacert,
  gitMinimal,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gittype";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "gittype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-343lPlLrfHHZEfhFEZGAXwzxGg1I2YpGQERcFU2bJZY=";
  };

  cargoHash = "sha256-tca8fV7KWd/Ab0+J3eymhjXZfGUsF6LXhgP4HKYisq4=";

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
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  nativeCheckInputs = [ gitMinimal ];

  checkFlags = lib.forEach (
    [
      "unit::infrastructure::git::remote_git_repository_client_test::tests::"
      "unit::domain::services::challenge_generator::challenge_generator_tests::"
      "unit::domain::models::loading::cloning_step_execute_tests::execute_uses_complete_cached_repository"
      "unit::domain::models::loading::extracting_step_execute_tests::execute_returns_no_supported_files_when_all_files_are_filtered_out"
      "unit::domain::models::loading::step_manager_tests::execute_pipeline_propagates_scanning_error_without_loading_screen"
    ]
    ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
      "unit::domain::services::scoring::tracker::stage::test_pause_resume"
      "unit::domain::services::scoring::calculator::stage::test_calculate_with_pauses"
      "unit::domain::services::scoring::calculator::stage::test_pause_resume"
    ]
  ) (test: "--skip=${test}");

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  strictDeps = true;
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
