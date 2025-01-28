{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
,  versionCheckHook
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-rKvnbauJpyZnJuLtGSjJKwe9wy/y/KLPyorH5u9t0H8=";
  };

  cargoHash = "sha256-++UXa5moUc7fhK2GJHm8bvvpBeL2MfRav7OnPldpsZ4=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    installShellCompletion ./scripts/completions/aichat.{bash,fish,zsh}
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Use GPT-4(V), Gemini, LocalAI, Ollama and other LLMs in the terminal";
    homepage = "https://github.com/sigoden/aichat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mwdomino ];
    mainProgram = "aichat";
  };
}
