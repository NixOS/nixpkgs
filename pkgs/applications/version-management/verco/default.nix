{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "verco";
  version = "6.8.0";

  src = fetchFromGitHub {
    owner = "vamolessa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E1kqJLnTLPu38zvDGaPHiKSW/yKormbx5N1CBSzQxgc=";
  };

  cargoSha256 = "sha256-9342LAChCv61kxTJoeOy7EdafMfR10s8dtkc2pTgXT0=";

  meta = with lib; {
    description = "A simple Git/Mercurial/PlasticSCM tui client based on keyboard shortcuts";
    homepage = "https://vamolessa.github.io/verco";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
