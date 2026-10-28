{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixmate";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "daskladas";
    repo = "nixmate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w9qE5zZ8mEHPbR84OuJoFWFvmMuKpvq/ANwyDUEvbPo=";
  };

  cargoHash = "sha256-87Q64EURBJJjW49sTB/qQB8dCZDq1PGyqI4fKYwR8yI=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "All your NixOS tools in one TUI — generations, rebuilds, services, errors, and more";
    homepage = "https://github.com/daskladas/nixmate";
    changelog = "https://github.com/daskladas/nixmate/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      GaetanLepage
      daskladas
    ];
    mainProgram = "nixmate";
  };
})
