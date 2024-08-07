{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clang-tidy-sarif";
  version = "0.6.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pQbhLbDRcZJhXXY6bWGO/8mmQRwgM3tDEWKoqmsNr68=";
  };

  cargoHash = "sha256-K+Cle2eCH4jCLbYfOrlEXeBvFUr7dGmpKFQM1IJi7p4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A CLI tool to convert clang-tidy diagnostics into SARIF";
    homepage = "https://psastras.github.io/sarif-rs";
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "clang-tidy-sarif";
    license = lib.licenses.mit;
  };
}
