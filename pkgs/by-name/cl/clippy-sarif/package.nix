{
  lib,
  fetchCrate,
  rustPlatform,
  clippy,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clippy-sarif";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-J2QtM6lrkOXQO3ZARJWIgjkj0pLzmL9id5b2JNkGeiA=";
  };

  cargoHash = "sha256-ovmL60aFlScPOxJ/ea3jGCsJrW+0XbY0zN8RTnkKRDA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI tool to convert clippy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "clippy-sarif";
    inherit (clippy.meta) platforms;
  };
}
