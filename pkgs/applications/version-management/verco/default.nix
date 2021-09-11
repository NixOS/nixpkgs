{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "verco";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "vamolessa";
    repo = pname;
    rev = "v${version}";
    sha256 = "09lkgqrv5wfpg7q5mqaiar93jp8gz8ys84hy7jhn1mvjml3zlbnx";
  };

  cargoSha256 = "04ddhhyad5cd3mg1yzx7mhr0g5mqfnmx9y0li82yx9wnv9br5qn6";

  meta = with lib; {
    description = "A simple Git/Mercurial/PlasticSCM tui client based on keyboard shortcuts";
    homepage = "https://vamolessa.github.io/verco";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
