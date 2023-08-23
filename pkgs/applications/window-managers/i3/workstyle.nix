{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "workstyle";
  version = "8bde72d9a9dd67e0fc7c0545faca53df23ed3753";

  src = fetchFromGitHub {
    owner = "pierrechevalier83";
    repo = pname;
    rev = "f2023750d802259ab3ee7d7d1762631ec157a0b1";
    sha256 = "04xds691sw4pi2nq8xvdhn0312wwia60gkd8b1bjqy11zrqbivbx";
  };

  cargoSha256 = "sha256-sefZLI9btbS3SwNL2x20WDtO1yR1jBCT3D85c6V9YGE=";

  doCheck = false; # No tests

  meta = with lib; {
    description = "Sway workspaces with style";
    homepage = "https://github.com/pierrechevalier83/workstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ FlorianFranzen ];
  };
}
