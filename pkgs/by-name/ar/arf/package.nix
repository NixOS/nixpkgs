{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  R,
  rPackages,
  coreutils,
  writableTmpDirAsHomeHook,
  air-formatter,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arf";
  version = "0.6.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eitsupi";
    repo = "arf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eMmuk4g7+vVFa2VuvbsEuRAGpPzh/hv016hz3rHBnmc=";
  };

  cargoHash = "sha256-aVb3SwPKpgQXPRQJpSQxlor0AFVoPtXfH7bndkwHnfk=";

  # Some tests spawn `/usr/bin/env` to relaunch arf with modified environment,
  # which does not exist inside the build sandbox.
  postPatch = ''
    substituteInPlace \
      crates/arf-console/tests/tui/support.rs \
      --replace-fail '/usr/bin/env' '${lib.getExe' coreutils "env"}'
  '';

  # The tests spawn R and the R packages `dplyr`/`askpass` (plus their
  # transitive dependencies). `R` in `buildInputs` is needed so that R's setup
  # hook populates `R_LIBS_SITE`; `R` in `nativeCheckInputs` is needed so that
  # `R` itself is on `PATH` (`buildRustPackage` sets `strictDeps`).
  buildInputs = [
    R
    rPackages.askpass
    rPackages.dplyr
  ];

  nativeCheckInputs = [
    air-formatter
    coreutils
    R
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export TERM=xterm-256color
    export LANG=C.UTF-8
    export LC_ALL=C.UTF-8
  '';

  # `history_menu_selection_replaces_existing_buffer` relies on pty timing, and
  # `formatter_process_receives_stdin_and_expected_arguments` races with the
  # sandbox filesystem (`ExecutableFileBusy`/ETXTBSY); both are flaky here.
  checkFlags = [
    "--skip=history::history_menu_selection_replaces_existing_buffer"
    "--skip=external::formatter::tests::formatter_process_receives_stdin_and_expected_arguments"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # These TUI tests time out on Darwin with sandboxing enabled.
    # The restart test also times out with sandboxing disabled.
    "--skip=history::replacing_error_option_leaves_history_status_unavailable"
    "--skip=restart::restart_preserves_environment_and_reconnects_ipc"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Alternative R Frontend — a modern R console written in Rust";
    homepage = "https://github.com/eitsupi/arf";
    changelog = "https://github.com/eitsupi/arf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "arf";
    maintainers = [
      lib.maintainers.brancengregory
      lib.maintainers.chvp
    ];
  };
})
