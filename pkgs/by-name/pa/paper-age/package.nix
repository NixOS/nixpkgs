{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "paper-age";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${version}";
    hash = "sha256-7dd1R41CDgkpFI8fUWCJfgz3lr22IjWQYW6vRYEFidc=";
  };

  cargoHash = "sha256-IJDV0dmOsA9gbVKGfPsN3TKJbox3JTNxldArQK6GPt8=";

  meta = with lib; {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "paper-age";
  };
}
