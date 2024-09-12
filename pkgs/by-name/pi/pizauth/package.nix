{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    rev = "pizauth-${version}";
    hash = "sha256-9NezG644oCLTWHTdUaUpJbuwkJu3at/IGNH3FSxl/DI=";
  };

  cargoHash = "sha256-Lp5ovkQKShgT7EFvQ+5KE3eQWJEQAL68Bk1d+wUo+bc=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postInstall = ''
    installShellCompletion --cmd pizauth \
      --bash share/bash/completion.bash
  '';

  meta = {
    description = "Command-line OAuth2 authentication daemon";
    homepage = "https://github.com/ltratt/pizauth";
    changelog = "https://github.com/ltratt/pizauth/blob/${src.rev}/CHANGES.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "pizauth";
  };
}
