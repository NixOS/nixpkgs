{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex-relay";
  version = "0.5.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MetaFARS";
    repo = "codex-relay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cdBzuurqJGT4EzgZbq4deXZKiJoOjCg+S1efnpk0/wU=";
  };

  cargoHash = "sha256-ak4yEKEf94NPvOlcoT97/X53sKu6+euwfWfbs52Tef0=";

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
