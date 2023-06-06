{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1frm41Vbo4t1BELq0rNGb1hY7RQLt8IJaEhtyNfNNdU=";
  };

  cargoSha256 = "sha256-UyO8oX54qVQA7nFx6Y/cSgb33Cz3M0kFeiYqUrSbCe0=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
