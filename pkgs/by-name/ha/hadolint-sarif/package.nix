{
  lib,
  fetchCrate,
  rustPlatform,
  hadolint-sarif,
  nix-update-script,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Zh3y31Q+ue1TqncZpdX+fAp2yfEnv8W8jkzUW7UvrKg=";
  };

  cargoHash = "sha256-bwEQ9lZXvZL6JN24N8gRdbV5gcFiH1fQ59PQILfW1z8=";

  passthru = {
    tests.version = testers.testVersion { package = hadolint-sarif; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI tool to convert hadolint diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "hadolint-sarif";
  };
}
