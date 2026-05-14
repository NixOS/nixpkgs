{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "0.9.23";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KtmXNlKPz4W2hfLa1iTPUVrocEjXWfTcoMwcznV4ZEk=";
  };

  cargoHash = "sha256-fx9/LVZrbwfGL03Xv53q4FaC6obKadZWesj4SfMvG78=";

  meta = {
    description = "TUI to find LLM models right sized for the system's RAM, CPU, and GPU";
    homepage = "https://github.com/AlexsJones/llmfit";
    changelog = "https://github.com/AlexsJones/llmfit/blob/v${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "llmfit";
  };
})
