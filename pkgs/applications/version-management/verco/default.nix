{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "verco";
  version = "6.5.5";

  src = fetchFromGitHub {
    owner = "vamolessa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-n+GGiu/xGGGC6FQPoASok87bCG0MFVIf6l6nt1lvw8A=";
  };

  cargoSha256 = "sha256-lNtR4N+bFFCr3Ct99DJCbtDeKxTzT7ZjvAWixbQm3jg=";

  meta = with lib; {
    description = "A simple Git/Mercurial/PlasticSCM tui client based on keyboard shortcuts";
    homepage = "https://vamolessa.github.io/verco";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
