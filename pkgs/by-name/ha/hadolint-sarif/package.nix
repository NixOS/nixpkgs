{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "hadolint-sarif";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7xvo194lCQpDtLgwX6rZEkwG3hYTp5czjw4GrEaivsI=";
  };

  cargoHash = "sha256-R4fGlo65/suNozEzRaQ3k6Ys4CMBheT2+rHZZZuIstM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool to convert hadolint diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "hadolint-sarif";
  };
}
