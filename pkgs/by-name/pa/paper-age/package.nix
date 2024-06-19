{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "paper-age";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${version}";
    hash = "sha256-hrqjnZmcGUgFWn8Z85oJEbeUBaF2SccytMr1AG0GGos=";
  };

  cargoHash = "sha256-sFofS+POvJwGo/+tiF6dawKgQci/54tUKkQQalqT+K0=";

  meta = with lib; {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "paper-age";
  };
}
