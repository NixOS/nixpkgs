{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-puChbaLjpm5FmpYIrb+3eKO9BSFu99R5j4ymKH5359Y=";
  };

  cargoSha256 = "sha256-DKpZQZgMR+gbcxxAD8ru5O4o7vr6n4seBVqor3HrYtY=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
