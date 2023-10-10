{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "paper-age";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "matiaskorhonen";
    repo = "paper-age";
    rev = "v${version}";
    hash = "sha256-/8t+4iO+rYlc2WjjECq5mk8t0af/whmzatU63r9sO98=";
  };

  cargoHash = "sha256-lLY3PINWGpdnNojIPT+snvLJTH4UEM7JWXdqrOLxibY=";

  meta = with lib; {
    description = "Easy and secure paper backups of secrets";
    homepage = "https://github.com/matiaskorhonen/paper-age";
    changelog = "https://github.com/matiaskorhonen/paper-age/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "paper-age";
  };
}
