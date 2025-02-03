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
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-VFwLys5lVVQw3dmfY1nrI+Bi0tm7kjD2/1c1DLczLwk=";
  };

  cargoHash = "sha256-zktbOyBa200YSZBuLs3xU95bh9kvj5XZQKb7tpiTs1I=";

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
