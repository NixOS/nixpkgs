{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    tag = "v${version}";
    hash = "sha256-rKvnbauJpyZnJuLtGSjJKwe9wy/y/KLPyorH5u9t0H8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WtEV+JkSaegshF8VB/OfuvnnKX5hDshCC/v5B2McA6M=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion ./scripts/completions/aichat.{bash,fish,zsh}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Use GPT-4(V), Gemini, LocalAI, Ollama and other LLMs in the terminal";
    homepage = "https://github.com/sigoden/aichat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mwdomino ];
    mainProgram = "aichat";
  };
}
