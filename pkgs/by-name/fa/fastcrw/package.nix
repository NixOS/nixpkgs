{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  cmake,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fastcrw";
  version = "0.33.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "us";
    repo = "crw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ltZoCLgIR7jBBsyggLwZspwqCNspH4+jqpadyQ2HS/0=";
  };

  cargoHash = "sha256-G4N82svyVX9MXRHLH9nrPXVl6PQWxVwzr8eRKYwezic=";

  # aws-lc-sys drives its C build through cmake and generates its bindings.
  nativeBuildInputs = [
    cmake
    rustPlatform.bindgenHook
  ];

  dontUseCmakeConfigure = true;

  # The crw-cli journeys drive the built binary against local mock servers, but
  # rustls still refuses to construct a client without a system trust store.
  nativeCheckInputs = [ cacert ];

  cargoTestFlags = [ "--no-fail-fast" ];

  # Optimizing test binaries with fat LTO takes over 100 minutes on Hydra,
  # while the tests themselves finish in about two minutes.
  checkType = "debug";

  checkFlags = [
    # Dial a blackhole address to assert the error is a connect-phase timeout;
    # the sandbox has no route at all, so it fails fast as "network unreachable".
    "--skip=http_only::tests::connection_failure_catches_connect_timeout"
    "--skip=http_only::tests::is_retriable_error_false_for_connect_timeout"

    # The SSRF guard resolves the destination before a request is accepted, so
    # in the sandbox these get "DNS resolution failed" instead of the response
    # they assert on. CRW_ALLOW_LOOPBACK_FOR_TESTS=1 skips the resolve, but it
    # is read process-wide and would neuter the SSRF tests in the same run.
    "--skip=crawl_concurrent_start_unique_ids"
    "--skip=crawl_concurrent_status_no_deadlock"
    "--skip=crawl_start_returns_job_id"
    "--skip=crawl_with_renderer_auto_accepted"
    "--skip=crawl_with_renderer_unavailable_returns_400"
    "--skip=mcp_crw_crawl_renderer_unavailable_returns_tool_error"
    "--skip=scrape_with_renderer_unavailable_returns_400"
    "--skip=v2_extract_blank_system_prompt_is_tolerated"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web scraper, crawler and search API with an MCP server for AI agents";
    homepage = "https://github.com/us/crw";
    changelog = "https://github.com/us/crw/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "crw";
  };
})
