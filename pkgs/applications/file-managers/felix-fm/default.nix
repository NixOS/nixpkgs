{ lib, rustPlatform, fetchFromGitHub, zoxide }:

rustPlatform.buildRustPackage rec {
  pname = "felix";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "kyoheiu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HD6KsPI4ZeJxQ+jbv5bWzTGQBHa9wGzhZBLQedcL5WI=";
  };

  cargoSha256 = "sha256-Q24dyCJBy27B3aI7ZEQnjTgLIB7XhltYeGBpmfy0DwE=";

  checkInputs = [ zoxide ];

  meta = with lib; {
    description = "A tui file manager with vim-like key mapping";
    homepage = "https://github.com/kyoheiu/felix";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fx";
  };
}
