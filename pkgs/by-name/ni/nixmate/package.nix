{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixmate";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "daskladas";
    repo = "nixmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Buabxhaq9P1u2zqRMGnFnCZczrxENa/Ux//F5wHkb1U=";
  };

  cargoHash = "sha256-c11NRt6qBNhj6JQeI7/80aYzuCY36ApsUWVnbRH7rRU=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "All your NixOS tools in one TUI — generations, rebuilds, services, errors, and more";
    homepage = "https://github.com/daskladas/nixmate";
    changelog = "https://github.com/daskladas/nixmate/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "nixmate";
  };
})
