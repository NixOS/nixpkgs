{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lluBxYZQWygX9aujNK251bDilNNErVNr4WDoyqSPTiQ=";
  };

  cargoSha256 = "sha256-GQNNl8/Y/jHDBGJQ7LWNpgbOgWaV/3UAMgYLJFJmQ3Y=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
