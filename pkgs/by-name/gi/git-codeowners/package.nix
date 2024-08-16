{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "git-codeowners";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "softprops";
    repo = "git-codeowners";
    rev = "v${version}";
    sha256 = "0bzq4ridzb4l1zqrj1r0vlzkjpgfaqwky5jf49cwjhz4ybwrfpkq";
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
