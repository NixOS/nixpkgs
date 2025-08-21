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
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pqu7jIKksjn52benebICQEhgCW59MX+RRTcHm2ufjWE=";
  };

  cargoHash = "sha256-wdJTQjDCmbJVPEUV6DENb2UegAc1ET4iSw3SzmlGPnA=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool to convert clippy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "clippy-sarif";
    inherit (clippy.meta) platforms;
  };
}
