{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfspeedtest";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = "cfspeedtest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EVZFmTjv2j7kax4MC5HTkVa7/IiDNZcIOgsntSGfzG4=";
  };

  cargoHash = "sha256-cA+eRVZiZL+bbPc+Vr7nkwMLbQBKOO3uU0XzrxVajqg=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cfspeedtest \
      --bash <($out/bin/cfspeedtest --generate-completion bash) \
      --fish <($out/bin/cfspeedtest --generate-completion fish) \
      --zsh <($out/bin/cfspeedtest --generate-completion zsh)
  '';

  # require internet access
  checkFlags = map (t: "--skip=${t}") [
    "speedtest::tests::test_fetch_metadata_integration"
    "speedtest::tests::test_run_tests_does_not_retry_non_retryable_4xx"
    "speedtest::tests::test_run_tests_retries_429_and_records_success"
    "speedtest::tests::test_run_tests_retry_delay_resets_after_success"
    "speedtest::tests::test_run_tests_retry_delay_uses_retry_streak_not_total_attempts"
    "speedtest::tests::test_run_tests_stops_after_max_attempts_on_retryable_failures"
    "speedtest::tests::test_upload_duration_excludes_delayed_response_body"
    "speedtest::tests::test_upload_retryable_failure_parses_retry_after_without_drain_skew"
  ];

  meta = {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    changelog = "https://github.com/code-inflation/cfspeedtest/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      colemickens
      stepbrobd
    ];
    mainProgram = "cfspeedtest";
  };
})
