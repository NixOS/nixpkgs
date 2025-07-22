{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "markdown-code-runner";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "markdown-code-runner";
    tag = finalAttrs.version;
    hash = "sha256-ZKjtOJ/HaOlLE3ozGRLbG20z1pmq6rIMr8jw4pOmy4Y=";
  };

  cargoHash = "sha256-dwHggLxy82dhssDSerOGaB2/DQed/b8PpTLJOkX7z1Q=";

  dontUseCargoParallelTests = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

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
