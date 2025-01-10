{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "git-codeowners";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "softprops";
    repo = "git-codeowners";
    rev = "v${version}";
    hash = "sha256-eF6X+fLkQ8lZIk4WPzlW7l05P90gB5nxD5Ss32Im+C8=";
  };

  cargoHash = "sha256-TayvqcVNCFHF5UpR1pPVRe076Pa8LS4duhnZLzYxkQM=";

  meta = with lib; {
    homepage = "https://github.com/softprops/git-codeowners";
    description = "Git extension to work with CODEOWNERS files";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    mainProgram = "git-codeowners";
  };
}
