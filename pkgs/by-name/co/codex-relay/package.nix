{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex-relay";
  version = "0.6.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MetaFARS";
    repo = "codex-relay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YuaguJJD9icqRegt7L2b0xLGjFavtM8sv4F2UxPdPJE=";
  };

  cargoHash = "sha256-9yB1HgNN5/F5SoJYK0trF+U13uYsKPwTrGDaQS8DjrU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Responses API ↔  Chat Completions translation bridge for Codex CLI";
    longDescription = ''
      A lightweight Rust proxy that translates the OpenAI Responses API
      (used by Codex CLI) into the Chat Completions API, letting Codex work
      with any OpenAI-compatible provider —  DeepSeek, Kimi, Qwen, Mistral,
      Groq, xAI, OpenRouter, and more.
    '';
    homepage = "https://github.com/MetaFARS/codex-relay";
    changelog = "https://github.com/MetaFARS/codex-relay/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    mainProgram = "codex-relay";
    maintainers = [ maintainers.andrewzah ];
  };
})
