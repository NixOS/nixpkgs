{ lib
, fetchFromGitHub
, crystal_0_33
}:

let
  crystal = crystal_0_33;

in crystal.buildCrystalPackage rec {
  pname = "thicket";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "taylorthurlow";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A89E0CbV7VFB7W4ycFcZloP0J/d42agEuD+hs9a6a6E=";
  };

  format = "shards";

  shardsFile = ./shards.nix;
  crystalBinaries.thicket.src = "src/thicket.cr";

  # there is one test that tries to clone a repo
  doCheck = false;

  meta = with lib; {
    description = "A better one-line git log";
    homepage = "https://github.com/taylorthurlow/thicket";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
