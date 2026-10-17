{
  buzz-cli,
  lib,
  runCommand,
  rustPlatform,
  stdenv,
  cacert,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-agent";
  # Shares the Buzz workspace source and Cargo lockfile with buzz-cli.
  inherit (buzz-cli)
    version
    src
    cargoHash
    preBuild
    env
    ;

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;
  strictDeps = true;

  cargoBuildFlags = [
    "--package=buzz-agent"
    "--bin=buzz-agent"
  ];

  cargoTestFlags = [
    "--package=buzz-agent"
  ];

  checkFlags = [
    # Test executes the `buzz-agent` binary via `.env_clear()`, which strips `SSL_CERT_FILE`
    # and fails TLS root initialization inside the Nix build sandbox.
    "--skip=cli_signin_aliases_reuse_legacy_cache_without_runtime_configuration"
    # Racy: stop reading at the prompt response before the steer rejection arrives.
    # https://github.com/block/buzz/pull/8091
    "--skip=steer_rejected_on_run_id_mismatch"
    "--skip=steer_rejected_on_empty_prompt"
  ]
  # The Databricks OAuth tests serve on 127.0.0.1 but connect to `localhost`,
  # which the Darwin build sandbox can't resolve.
  ++ lib.optionals stdenv.hostPlatform.isDarwin (
    map (test: "--skip=databricks::tests::${test}") [
      "shared_diagnostics_never_log_oauth_bodies_urls_opener_or_callback_details"
      "shared_exact_limit_responses_and_grant_classifications_are_preserved"
      "shared_oauth_limits_bound_chunked_and_declared_bodies_in_both_paths"
      "strict_browser_wait_cancellation_releases_callback_listener"
      "strict_cancellation_drops_real_http_work_and_allows_retry"
      "strict_catalog_errors_redact_provider_text_and_urls"
      "strict_catalog_preserves_empty_filter_partial_and_paging_semantics"
      "strict_connect_code_exchange_catalog_and_headless_401_refresh"
      "strict_never_follows_discovery_token_or_catalog_redirects"
    ]
  );

  nativeCheckInputs = [ cacert ];

  passthru.tests.acp-initialize =
    runCommand "buzz-agent-acp-initialize"
      {
        # The LLM HTTP client loads the system CA bundle at startup.
        nativeBuildInputs = [
          finalAttrs.finalPackage
          cacert
        ];
      }
      ''
        export HOME=$TMPDIR
        echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1,"clientCapabilities":{}}}' \
          | BUZZ_AGENT_PROVIDER=anthropic ANTHROPIC_API_KEY=test ANTHROPIC_MODEL=test buzz-agent > reply.json
        grep -F '"agentInfo":{"name":"buzz-agent"' reply.json
        touch $out
      '';

  meta = {
    description = "Agent for the Buzz workspace that speaks ACP and calls MCP tools";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "buzz-agent";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
