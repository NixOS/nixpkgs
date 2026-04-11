{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmfit";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmfit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IOAY1aTt2wvwp7lNxaD4Svm1xwDGR03aZ7WvpXStrHc=";
  };

  cargoHash = "sha256-74uFCzSkX9TxMJjz/37ASQoWfuzNK/iAAc5pPfJl5NI=";

  meta = {
    description = "Find what runs on your hardware";
    homepage = "https://github.com/AlexsJones/llmfit";
    changelog = "https://github.com/AlexsJones/llmfit/releases/tag/v${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "llmfit";
  };
})
