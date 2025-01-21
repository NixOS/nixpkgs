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
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "aichat";
    rev = "v${version}";
    hash = "sha256-Hqrwko/HZTHlKzXuqm835fpygOO9wsQx1XkJddH/EUc=";
  };

  cargoHash = "sha256-4CcwzaPIO+upISizpXHGYfKh9YD4foJAqx7TGgLCHZI=";

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
