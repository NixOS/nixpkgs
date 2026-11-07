{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nodejs,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "runx";
  version = "0.10.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "runxhq";
    repo = "runx";
    tag = "cli-v${finalAttrs.version}";
    hash = "sha256-/VlHo1Rfzcir38GH3R2JOykG4PBr6Xl0QhoHQWxKWYQ=";
  };

  cargoRoot = "crates";
  buildAndTestSubdir = "crates";
  cargoHash = "sha256-w5PUIm+QZVH8Xy8YEGeJlgsIL9/IxFMB+MwFW8vZwFg=";

  # The CLI runs JavaScript skills through the worker installed beside it.
  cargoBuildFlags = [
    "--package=runx-cli"
    "--package=runx-js-worker"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # Skill fixtures in the CLI's integration tests run JavaScript tools with Node.
  nativeCheckInputs = [ nodejs ];

  checkFlags = [
    # These give their fixture programs /usr/bin:/bin as PATH, which the build
    # sandbox lacks. Fixed upstream in runxhq/runx@b81306d4.
    "--skip=connector::a_reference_binds_through_the_managers_cli_and_listing_reads_nothing"
    "--skip=connector::a_session_command_runs_only_once_the_operator_names_it"
    "--skip=credential::the_model_key_from_a_reference_keeps_only_the_reference"
    "--skip=skill::terminal_interrupt_kills_the_active_javascript_worker_before_the_watchdog"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  postInstallCheck = ''
    mkdir -p "$TMPDIR/runx-smoke" "$TMPDIR/receipts"
    cat > "$TMPDIR/runx-smoke/SKILL.md" <<'EOF'
    ---
    name: nix-smoke
    description: Verify the installed runx JavaScript worker.
    ---

    Run the packaging probe.
    EOF
    cat > "$TMPDIR/runx-smoke/run.yaml" <<'EOF'
    skill: nix-smoke
    runners:
      run:
        default: true
        result_from: [probe]
        steps:
          - id: probe
            tool: { module: probe.mjs, export: probe }
            outputs:
              value: string
    EOF
    echo 'export function probe() { return { value: "nix-worker-ok" }; }' > "$TMPDIR/runx-smoke/probe.mjs"
    (cd "$TMPDIR" && HOME="$TMPDIR" "$out/bin/runx" skill "$TMPDIR/runx-smoke" --receipt-dir "$TMPDIR/receipts" --json > "$TMPDIR/runx-smoke.json")
    grep -F '"status":"sealed"' "$TMPDIR/runx-smoke.json"
    grep -F 'nix-worker-ok' "$TMPDIR/runx-smoke.json"
  '';

  meta = {
    description = "Governed runtime for agent skills";
    homepage = "https://runx.ai";
    changelog = "https://github.com/runxhq/runx/releases/tag/cli-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "runx";
  };
})
