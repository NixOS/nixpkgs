{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "markdown-code-runner";
  version = "0-unstable-2025-04-18";

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "markdown-code-runner";
    rev = "9907df63574d714abcd78f9dfdf4bdda73ff30d6";
    hash = "sha256-Bn+IsZzV07bm5TNRX3+OOuxi3kj7d73gYPzcdIxWMi8=";
  };

  cargoHash = "sha256-HOJCnuzd6i4v1SpR4jstlpNkvSgH/4kvvE6Lsr4cgbI=";

  dontUseCargoParallelTests = true;

  meta = {
    description = "Configurable Markdown code runner that executes and optionally replaces code blocks using external commands";
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
