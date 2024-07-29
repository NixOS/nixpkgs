{ lib
, stdenv
, darwin
, rustPlatform
, fetchFromGitHub
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "aichat";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-75KL1ODA+HyG/YRQIDs3++RgxQHyxKj6zh/2f6zQbdY=";
  };

  cargoHash = "sha256-pLQ3P+0SdM3QMqO3AdwYOJKFH3Jqz6ID/J1V5dBGG6s=";

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

  meta = with lib; {
    description = "Use GPT-4(V), Gemini, LocalAI, Ollama and other LLMs in the terminal";
    homepage = "https://github.com/sigoden/aichat";
    license = licenses.mit;
    maintainers = with maintainers; [ mwdomino ];
    mainProgram = "aichat";
  };
}
