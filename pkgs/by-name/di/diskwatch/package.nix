{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "diskwatch";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "matthart1983";
    repo = "diskwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ugqda8QWiHlNcMFIrenoHVD2WCK9JgcfoCNNOwBuQMY=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-MjRU/NDZIbxIXFiU6sdfPfvcszkmbVeDAC0rb+Sz/6s=";

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
