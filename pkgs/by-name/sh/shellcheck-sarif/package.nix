{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "shellcheck-sarif";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ZVzUEhhiL5KeOck6Jmg1LKyQ3oHc6OQXSrSlC1s6qpA=";
  };

  cargoHash = "sha256-ftTGtvpIR8NymkJkUTZzV7KdS0aHutu4WAZ4CQZd3jE=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool to convert shellcheck diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "shellcheck-sarif";
  };
}
