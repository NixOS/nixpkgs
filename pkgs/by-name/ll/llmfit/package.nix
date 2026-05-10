{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "0.9.18";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0NswrJNA6IPqL5RaZyVyMc4p6UI7ZiWnjlnyTC4nW6o=";
  };

  cargoHash = "sha256-pI3n53GSyM/HDyZ4frFzDENthupmCMC2aQOERVBMUJ4=";

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
