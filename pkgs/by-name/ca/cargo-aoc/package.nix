{
  lib,
  rustPlatform,
  fetchCrate,
  testers,
  nix-update-script,
  cargo-aoc,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-aoc";
  version = "0.3.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5CjY91515GeLzmLJiGjfbBfIMPr32EA65X/rriKPWRY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-q0kpo6DNR+8129+vJSLoOC/bUYjlfaB77YTht6+kT00=";

  passthru = {
    tests.version = testers.testVersion { package = cargo-aoc; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple CLI tool that aims to be a helper for Advent of Code";
    homepage = "https://github.com/gobanos/cargo-aoc";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "cargo-aoc";
  };
}
