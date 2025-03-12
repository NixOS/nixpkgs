{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "pizauth";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "ltratt";
    repo = "pizauth";
    tag = "pizauth-${version}";
    hash = "sha256-x3LdutVrQFrkXvbGPVzBV7Y8P9okKgv2rh2YdnDXvsc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5xrPCGvWHceZYPycQdH1wwOH6tmJxHBshOE5866YiKg=";

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
