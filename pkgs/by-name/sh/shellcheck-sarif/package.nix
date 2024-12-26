{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "shellcheck-sarif";
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-cgcvl/nlnJtYzTfxbJHJ967zFH8KtWTMZPKGVpH66z0=";
  };

  cargoHash = "sha256-wGr9UQ9zJ8EJCrYOgYmRO9Oy7jtxPNRnIZROmf7xwmk=";

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
