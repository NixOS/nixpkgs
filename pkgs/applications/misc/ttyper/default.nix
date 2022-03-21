{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e001uftwIwnCpjf4OH89QWaYyT99aMZhCPqDxyAsHyU=";
  };

  cargoSha256 = "sha256-RvqktyPZtdKC8RVtLWpT1YYsdgyfHaL7W3+vO8RgG/8=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
