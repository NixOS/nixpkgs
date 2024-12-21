{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "rain";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "cenkalti";
    repo = "rain";
    rev = "refs/tags/v${version}";
    hash = "sha256-bn1LblXwYqZxfCuOmnmWo4Q8Ltt7ARnDCyEI7iNuYHU=";
  };

  vendorHash = "sha256-SX686l6fsr3Gm+gyzNUZUSGXwAnxaTvUo/J57N10fmU=";

  meta = {
    description = "BitTorrent client and library in Go";
    homepage = "https://github.com/cenkalti/rain";
    license = lib.licenses.mit;
    mainProgram = "rain";
    maintainers = with lib.maintainers; [
      justinrubek
      matthewdargan
    ];
  };
}
