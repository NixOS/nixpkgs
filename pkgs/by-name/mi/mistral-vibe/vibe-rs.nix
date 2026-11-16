{
  lib,
  stdenv,
  rustPlatform,
  pkg-config,
  alsa-lib,
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

  cargoHash = "sha256-s8Db0TAGAsczGTlALEJRSVWZXitvlasULbVfMvcD8JU=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Needed to build `coreaudio-sys` (pulled by `cpal`)
    rustPlatform.bindgenHook
  ];

  buildInputs = [
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
