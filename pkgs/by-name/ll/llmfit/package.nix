{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6mARQqRsPtsN0WAp4oKqG1jl062BqDJ1D9AZBLomel8=";
  };

  cargoHash = "sha256-iUh9VBtDfuil96av1I5XlO/mZ/Q9HccBJitBfJ+i69A=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI to find LLM models right sized for the system's RAM, CPU, and GPU";
    homepage = "https://github.com/AlexsJones/llmfit";
    changelog = "https://github.com/AlexsJones/llmfit/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "llmfit";
  };
})
