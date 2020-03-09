{ lib
, fetchFromGitHub
, crystal
}:

crystal.buildCrystalPackage rec {
  pname = "thicket";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "taylorthurlow";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hkmmssiwipx373d0zw9a2yn72gqzqzcvwkqbs522m5adz6qmkzw";
  };

  shardsFile = ./shards.nix;
  crystalBinaries.thicket.src = "src/thicket.cr";

  meta = with lib; {
    description = "A better one-line git log";
    homepage = "https://github.com/taylorthurlow/thicket";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}