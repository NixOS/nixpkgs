{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diskwatch";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "diskwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pveHyT3ljQQ9GdOMhZhcY7QD/pMvL3fLrbM6D5fO+h4=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-PufgQqJGsPMBcnNV/QXQnE/wrI4FAJWXLvoHEqLQm5k=";

  nativeCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-V" ];

  meta = {
    description = "Single-host, read-only disk diagnostics TUI";
    homepage = "https://github.com/matthart1983/diskwatch";
    changelog = "https://github.com/matthart1983/diskwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "diskwatch";
  };
})
