{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "shellcheck-sarif";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PFMakiV9vXzMqVh1WeVTDwGpN7RVfFQlVWKkaD6ef+Q=";
  };

  cargoHash = "sha256-kkSTRoouuIh4Bsh+zqhtTwIGLxDE+3u8SuP+8i+lw5Q=";

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
