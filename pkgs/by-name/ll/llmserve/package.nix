{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmserve";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmserve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j4ko8AkrIOWlM1Tkl/pGMI1PzQc6yImCAZXEmO/NBko=";
  };

  cargoHash = "sha256-jwCQSm4k1YofCn2r5IX+knXbTo70bsAVHIxojeLpkqI=";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for serving local LLM models";
    homepage = "https://github.com/AlexsJones/llmserve";
    changelog = "https://github.com/AlexsJones/llmserve/blob/v${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ afh ];
    mainProgram = "llmserve";
  };
})
