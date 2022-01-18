{ lib
, fetchFromGitHub
, crystal
}:

crystal.buildCrystalPackage rec {
  pname = "thicket";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "taylorthurlow";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7X1RKj/FWgJdgA7P746hU0ndUM49fH79ZNRSkvNZYFg=";
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
