{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "markdown-code-runner";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "markdown-code-runner";
    tag = finalAttrs.version;
    hash = "sha256-0AIW9rRIGKOCVdOmWH+vs4T3k++joo8DQpdiok6aAX0=";
  };

  cargoHash = "sha256-Q2KhNPrUU8X95Z7qsWqwkFDzJlLAmpH1Fn5f47fYr1o=";

  dontUseCargoParallelTests = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
})
