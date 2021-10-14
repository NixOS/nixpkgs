{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "verco";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "vamolessa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZfiGDEx6gjYziatbQSpqghmpXMXSPPBtTVYjll922t8=";
  };

  cargoSha256 = "sha256-jrA6vGw+lyfix8L3INBamrJ4pab5denPzWwjF0dRXB0=";

  meta = with lib; {
    description = "A simple Git/Mercurial/PlasticSCM tui client based on keyboard shortcuts";
    homepage = "https://vamolessa.github.io/verco";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
