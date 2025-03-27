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
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    tag = "v${version}";
    hash = "sha256-gs2nkZhz26tmFbAShLsFOgYt/RlPiqKTmdaPSG96m3E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cDYxT8WvryTLzBeMtp/iObdSfF84W1XT8ZN/nmoZfFY=";

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
