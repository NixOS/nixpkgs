{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rainfrog";
  version = "0.4.5";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kA3rIGmSid3qbIasqoSnFv4w0P+RrAWoH8PszY9xSGs=";
  };

  cargoHash = "sha256-A3gZF2oJVt5WR56JVwsPOVvgu/d9veD01+gQESNV0Qc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/achristmascarl/rainfrog/releases/tag/v${finalAttrs.version}";
    description = "Database management TUI for postgres";
    homepage = "https://github.com/achristmascarl/rainfrog";
    license = lib.licenses.mit;
    mainProgram = "rainfrog";
    maintainers = with lib.maintainers; [ patka ];
  };
})
