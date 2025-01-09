{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "ingrid_core";
  version = "1.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/B7EEq101Bu4y+rFY9ISI7kGPXEfMdOzf+Oj9w/ND2U=";
  };
  cargoHash = "sha256-wO2b5Ckt6vtWjbYPfmrKSo9+KomGBL3PTk/UbMHn2sM=";

  meta = with lib; {
    description = "Crossword-generating library and CLI tool";
    homepage = "https://ingrid.cx";
    mainProgram = "ingrid_core";
    maintainers = with maintainers; [ nulladmin1 ];
    license = licenses.mit;
  };
}
