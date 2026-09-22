{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llmserve";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "AlexsJones";
    repo = "llmserve";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V0DtCjTQhgfO/WQy/OZc2ayDY9nl2YzstCnsoRAJDFo=";
  };

  cargoHash = "sha256-5svPhLTpWfJgDVNyoytF42efiXzSZ2vbbrglSuNl3Ck=";

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
