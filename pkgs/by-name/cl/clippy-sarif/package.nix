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
  version = "0.6.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-GoVUOtxgLKEG+G1vgmFqtm0b2NRl4bhIe7DVo1tOqaw=";
  };

  cargoHash = "sha256-DZdU1QyIvzHm9UekqA2nZUKSRcgn7pKQFhPkPcAVFPY=";

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
