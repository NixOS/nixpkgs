{ lib
, crystal
, fetchFromGitHub
}:

crystal.buildCrystalPackage rec {
  pname = "thicket";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "taylorthurlow";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sF+fNKEZEfjpW3buh6kFUpL1P0yO9g4SrTb0rhx1uNc=";
  };

  format = "shards";

  crystalBinaries.thicket.src = "src/thicket.cr";

  # there is one test that tries to clone a repo
  doCheck = false;

  meta = with lib; {
    description = "Better one-line git log";
    homepage = "https://github.com/taylorthurlow/thicket";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "thicket";
  };
}
