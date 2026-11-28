{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex-relay";
  version = "0.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MetaFARS";
    repo = "codex-relay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6V3SU3KBApNBCf9p4mnkiW29CvF5FIk1VRdXJk9ipGQ=";
  };

  cargoHash = "sha256-3c9jWgUpfvdpUB6XV2jHFk/TbWVI51mbnR9J+3QI8IQ=";

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
