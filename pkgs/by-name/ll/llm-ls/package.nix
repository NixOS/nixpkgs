{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "llm-ls";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "llm-ls";
    tag = version;
    hash = "sha256-ICMM2kqrHFlKt2/jmE4gum1Eb32afTJkT3IRoqcjJJ8=";
  };

  cargoPatches = [
    # https://github.com/huggingface/llm-ls/pull/102
    ./fix-time-compilation-failure.patch
    (fetchpatch {
      name = "fix-version.patch";
      url = "https://github.com/huggingface/llm-ls/commit/479401f3a5173f2917a888c8068f84e29b7dceed.patch?full_index=1";
      hash = "sha256-4gXasfMqlrrP8II+FiV/qGfO7a9qFkDQMiax7yEua5E=";
    })
  ];
  cargoHash = "sha256-m/w9aJZCCh1rgnHlkGQD/pUDoWn2/WRVt5X4pFx9nC4=";

  buildAndTestSubdir = "crates/llm-ls";

  nativeBuildInputs = [ pkg-config ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "LSP server leveraging LLMs for code completion (and more?)";
    homepage = "https://github.com/huggingface/llm-ls";
    changelog = "https://github.com/huggingface/llm-ls/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jfvillablanca ];
    platforms = lib.platforms.all;
    mainProgram = "llm-ls";
  };
}
