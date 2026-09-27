{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-tools";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "mcmah309";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AQShxdXViRS7em9afIpxsS/pCrpXyT72p5K02sWicyw=";
  };

  cargoHash = "sha256-fyFQXMmG4GtXxR2c8YMHTdpd12vMOmMUO9vpaNe0sUY=";

  meta = {
    description = "A flexible CLI tool for organizing files and creating mdBooks";
    homepage = "https://github.com/mcmah309/mdbook-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "mdbook-tools";
  };
}
