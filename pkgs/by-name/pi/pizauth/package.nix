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
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    rev = "refs/tags/pizauth-${version}";
    hash = "sha256-x3LdutVrQFrkXvbGPVzBV7Y8P9okKgv2rh2YdnDXvsc=";
  };

  cargoHash = "sha256-moRr8usrFHE8YPQnsmeKoDZPAk94qRm9cHzHBLXtGFM=";

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
