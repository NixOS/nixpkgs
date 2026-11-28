{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  alsa-lib,
  aws-lc,
  oniguruma,
  cacert,
  coreutils,
  gitMinimal,

  version,
  src,
  meta,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vibe-rs";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/vibe/cli-rust";

  cargoHash = "sha256-DQIkrj/grVTh/4K5iSgqGd9gcWfcPhRKFqigmdlHv4s=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Needed to build `coreaudio-sys` (pulled by `cpal`)
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    aws-lc
    oniguruma
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  env.RUSTONIG_SYSTEM_LIBONIG = true;

  # Fake clipboard tools in the tests call `/bin/cat`, which is absent from the sandbox
  postPatch = ''
    substituteInPlace \
      tests/isolated/clipboard_linux.rs \
      tests/isolated/clipboard_tmux.rs \
      tests/isolated/tmux_mouse.rs \
      tests/isolated/tmux_mouse_hint.rs \
      --replace-fail \
        "/bin/cat" \
        "${lib.getExe' coreutils "cat"}"
  '';

  nativeCheckInputs = [
    # reqwest (sentry) fails to build without CA certificates
    cacert
    gitMinimal
  ];

  # The `isolated` test target needs one process per test
  useNextest = true;

  checkFlags = [
    # Flaky under load: the CLI sometimes never reports stopping after Ctrl+Z
    # (timed out waiting for a CLI event)
    "--skip"
    "suspend_lifecycle::"

    # Flaky under load: these count pooled app-servers after a fixed 300ms sleep
    # assertion `left == right` failed
    "--skip"
    "an_app_server_takes_k_runs_and_the_next_one_starts_another"
    "--skip"
    "an_app_server_takes_16_runs_by_default"
    "--skip"
    "a_run_awaiting_its_close_acknowledgement_takes_no_room"
    "--skip"
    "an_app_server_exits_once_its_last_run_ends"
    "--skip"
    "new_runs_fill_the_fuller_app_server_so_the_other_drains_and_exits"
    "--skip"
    "a_crashed_app_server_fails_only_its_own_runs"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # The file watcher never reports changes in the sandbox (timeout)
    "--skip"
    "file_index::a_rapid_burst_of_creates_settles_into_few_rebuilds"
    "--skip"
    "file_index::watch_mode_reindexes_a_file_created_after_the_initial_build"
  ];

  # Tests spin up mock HTTP servers on 127.0.0.1
  __darwinAllowLocalNetworking = true;

  cargoBuildFlags = [
    "--bin"
    "vibe-rs"
  ];

  meta = {
    description = "Rust TUI for Mistral Vibe";
    inherit (meta)
      homepage
      changelog
      license
      maintainers
      ;
    mainProgram = "vibe-rs";
  };
})
