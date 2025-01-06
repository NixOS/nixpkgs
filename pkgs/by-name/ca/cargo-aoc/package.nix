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

  cargoHash = "sha256-LhPsiO0Fnx9Tf+itaaVaO1XgqM00m+UQMlUJYY8isXY=";

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
