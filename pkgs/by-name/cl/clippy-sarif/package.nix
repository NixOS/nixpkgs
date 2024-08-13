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
  version = "0.6.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-vwHb622JIJr+iRx/MhWdXoRULnKqtxx6HB4rv9zpYA8=";
  };

  cargoHash = "sha256-bRB6DedlvFsHcjTJQiGn///M9YOp1rl9FxXQlzuI0vo=";

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
