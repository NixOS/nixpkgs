{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.9.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-u61gmkO7eij7r1A1RPk0ro+pml7ZmMsg0ukJLCFNaD0=";
  };

  cargoHash = "sha256-HBfCTOETQ1hHzLFDw12W58omRmliiWDFGSrmr3PELD8=";

  cargoBuildFlags = [
    "--bin"
    "svlint"
  ];

  meta = with lib; {
    description = "SystemVerilog linter";
    mainProgram = "svlint";
    homepage = "https://github.com/dalance/svlint";
    changelog = "https://github.com/dalance/svlint/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
