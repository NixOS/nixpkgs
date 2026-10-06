{
  lib,
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
  version = "0.5.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eitsupi";
    repo = "arf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ema0s5whJwYY9Bg3HSKf1XFWqANzuoJgpqSVsVKBoWg=";
  };

  cargoHash = "sha256-yGV/JSqK03bSoHsvbDyg4d+1Zf59nsT8tg9YH4oL7Lg=";

  # The test suite spawns helper scripts with a `#!/bin/sh` shebang, which does
  # not exist inside the build sandbox.
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
