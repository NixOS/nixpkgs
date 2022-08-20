{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rdQaUaNBnYCU11OMLqnidPYiJB2Ywly6NVw2W40kxng=";
  };

  cargoSha256 = "sha256-jJAluIyyU9XfN4BEZw2VbJHZvJ+6MJ781lvbAueUhKM=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda max-niederman ];
  };
}
