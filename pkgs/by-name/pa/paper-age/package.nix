{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "paper-age";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${version}";
    hash = "sha256-JlmiHnST/UnN4WsiDqSva+01odoc5h/J/mlGN3K0OfI=";
  };

  cargoHash = "sha256-zdq036ag7+mvWg4OJHtbltPlF9j49dCPNJjgVQcQ+u4=";

  meta = with lib; {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "paper-age";
  };
}
