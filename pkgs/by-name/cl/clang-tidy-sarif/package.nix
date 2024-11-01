{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clang-tidy-sarif";
  version = "0.6.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-rZnGueaqK7h8tWwwWacvFBvJwE1li2wN9iB4DJRHJ8U=";
  };

  cargoHash = "sha256-mELx6UGHV+qtL1G3+xvYUaUzZbfMy0dKgai6IqdbT+A=";

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
