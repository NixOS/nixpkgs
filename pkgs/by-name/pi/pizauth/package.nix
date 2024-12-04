{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  apple-sdk_11,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    rev = "refs/tags/pizauth-${version}";
    hash = "sha256-9NezG644oCLTWHTdUaUpJbuwkJu3at/IGNH3FSxl/DI=";
  };

  cargoHash = "sha256-Lp5ovkQKShgT7EFvQ+5KE3eQWJEQAL68Bk1d+wUo+bc=";

  # pizauth cannot be built with default apple-sdk_10 on x86_64-darwin, pin to 11
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11;

  nativeBuildInputs = [ installShellFiles ];

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
