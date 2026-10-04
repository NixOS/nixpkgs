{
  lib,
  rustPlatform,
  fetchFromGitHub,
  R,
  rPackages,
  bashInteractive,
  writableTmpDirAsHomeHook,
  air-formatter,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arf";
  version = "0.5.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eitsupi";
    repo = "arf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cmIx03Ll5HryrrHAmQ2B5WenAmIWqehCM3MzjoGSvyk=";
  };

  cargoHash = "sha256-q5Xe95JfkqzNv1CzBFDg/WKqu4g4vnrKLE52qPDU2Bo=";

  # The test suite spawns helper scripts with a `#!/bin/sh` shebang, which does
  # not exist inside the build sandbox.
  postPatch = ''
    substituteInPlace \
      crates/arf-console/src/external/formatter.rs \
      crates/arf-console/tests/resolve_tests.rs \
      crates/arf-console/tests/tui/prompt.rs \
      crates/arf-console/tests/tui/reprex.rs \
      --replace-fail '#!/bin/sh' '#!${lib.getExe bashInteractive}'
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
    bashInteractive
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
