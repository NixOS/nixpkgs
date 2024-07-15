{
  lib,
  fetchCrate,
  rustPlatform,
  clang-tidy-sarif,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "clang-tidy-sarif";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lxZtuE6hvmeX2CCO8UeGDORnCV5N7ZNiVZR+9LOCrdk=";
  };

  cargoHash = "sha256-R0IyXinUhIVqGal2Vt0EdU0EFyzs3KIbp/UIseWlj1Y=";

  passthru = {
    tests.version = testers.testVersion { package = clang-tidy-sarif; };
  };

  meta = {
    description = "A CLI tool to convert clang-tidy diagnostics into SARIF";
    mainProgram = "clang-tidy-sarif";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with lib.maintainers; [ getchoo ];
    license = lib.licenses.mit;
  };
}
