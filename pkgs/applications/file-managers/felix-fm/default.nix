{ lib, rustPlatform, fetchFromGitHub, zoxide }:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ewPDbrOxinu+GXegunZjumTCnkflXQk74Ovr8QStDBM=";
  };

  cargoSha256 = "sha256-wD0h8tXnqQOuBbFmpjMu0ZK7+omcOSqno6wFnSMTSjk=";

  checkInputs = [ zoxide ];

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
