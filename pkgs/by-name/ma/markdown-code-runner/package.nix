{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "markdown-code-runner";
  version = "0-unstable-2025-04-13";

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "markdown-code-runner";
    rev = "b39cdf8990e1a25adc958f58e87a12544724ca9d";
    hash = "sha256-JvsxS+qRrYzWzPlrCAccaPYPROGULCh1Gs5RAlL7dBo=";
  };

  cargoHash = "sha256-VAM6wQyvbSeFUEflDASU9a1xDzYEvyFPbp/wxpQxPX0=";
  dontUseCargoParallelTests = true;

  checkFlags = [
    # Flaky tests
    "--skip=test_check_mode_detects_differences"
    "--skip=test_check_mode_no_changes_returns_zero"
    "--skip=test_dry_run_allows_command_failure"
    "--skip=test_dry_run_does_not_fail_on_error"
    "--skip=test_dry_run_outputs_warning_but_does_not_write"
  ];

  meta = {
    description = "A configurable Markdown code runner that executes and optionally replaces code blocks using external commands";
    longDescription = ''
      markdown-code-runner is a command-line tool that scans Markdown files for fenced code blocks,
      executes them using per-language configuration, and optionally replaces the block content
      with the command output.

      It is useful for documentation that stays in sync with linters, formatters, or scripts.
      The tool supports placeholder substitution, configurable replace/check modes, and CI-friendly validation.
    '';
    homepage = "https://github.com/drupol/markdown-code-runner";
    license = lib.licenses.eupl12;
    mainProgram = "mdcr";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
}
