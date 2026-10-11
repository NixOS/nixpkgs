{
  buzz-cli,
  lib,
  runCommand,
  rustPlatform,
  stdenv,
  cacert,
  gitMinimal,
  jq,
  python3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-acp";
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

  cargoBuildFlags = [ "--package=buzz-acp" ];
  cargoTestFlags = [ "--package=buzz-acp" ];

  nativeCheckInputs = [
    # Tests build HTTP clients, which need the system CA certificates.
    cacert
    # Test fixtures run git and python3.
    gitMinimal
    python3
  ];

  checkFlags =
    map (test: "--skip=${test}") [
      # These run fake agents from `#!/bin/bash` and `#!/usr/bin/env` scripts,
      # and neither path exists in the build sandbox.
      "acp::launch::tests::wrapper_preserves_worker_identity_and_runs_on_each_spawn"
      "acp::tests::claude_named_adapter_wire_lifecycle_records_prompt_and_cost"
      "pool::pi_prompt_tests::pi_composed_prompt_uses_meta_without_capability_negotiation"
      "pool::pi_prompt_tests::pi_launch_preserves_existing_skills_in_explicit_workspace"
      "pool::pi_prompt_tests::upstream_pi_acp_launch_does_not_receive_managed_skills"
      # Runs buzz-acp with a cleared environment, which drops SSL_CERT_FILE, so
      # building its HTTP client fails.
      "task_native_git_and_startup_shutdown_cleanup"
    ]
    # Timing-sensitive: the slower Darwin builders miss these deadlines.
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--skip=acp::tests::idle_resets_on_stdout_activity"
      "--skip=acp::tests::keepalive_resets_idle_past_deadline"
    ];

  # One prepared task, run against upstream's scripted ACP agent (no model).
  passthru.tests.run-task =
    runCommand "buzz-acp-run-task"
      {
        # The relay client loads the system CA bundle at startup.
        nativeBuildInputs = [
          finalAttrs.finalPackage
          cacert
          gitMinimal
          jq
          python3
        ];
      }
      ''
        export HOME=$TMPDIR TASK_AGENT_LOG=$TMPDIR/wire.jsonl
        # Test-only key (secret key 1) and its public key.
        echo '{"version":1,"taskId":"smoke","agentPubkey":"79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798","prompt":"hello","maxDurationMs":10000}' \
          | buzz-acp run \
            --private-key 0000000000000000000000000000000000000000000000000000000000000001 \
            --relay-url ws://127.0.0.1:1 \
            --no-memory \
            --agent-command python3 \
            --agent-args ${finalAttrs.src}/crates/buzz-acp/tests/fixtures/task_agent.py \
            --task - > result.json
        jq -e '.status == "completed" and .stopReason == "end_turn"' result.json
        touch $out
      '';

  meta = {
    description = "Harness that connects ACP agents such as Goose, Codex and Claude Code to Buzz";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "buzz-acp";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
