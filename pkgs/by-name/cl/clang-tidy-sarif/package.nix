{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clang-tidy-sarif";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ALwEsF1n6WYqITfYTn8mIyn3sxTbDux17FxKIorKkFc=";
  };

  cargoHash = "sha256-cTBXStAA+oCRze2Bh/trultdqtBNOOpXQltJ6R34nF8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool to convert clang-tidy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "clang-tidy-sarif";
    license = lib.licenses.mit;
  };
}
