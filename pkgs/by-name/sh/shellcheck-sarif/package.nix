{
  lib,
  fetchCrate,
  rustPlatform,
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

  meta = {
    description = "CLI tool to convert shellcheck diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    mainProgram = "shellcheck-sarif";
    maintainers = with lib.maintainers; [ getchoo ];
    license = lib.licenses.mit;
  };
}
