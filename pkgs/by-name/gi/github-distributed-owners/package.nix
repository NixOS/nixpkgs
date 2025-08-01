{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "github-distributed-owners";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "andrewring";
    repo = "github-distributed-owners";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oLRcH1lgRxlYIlyk3bPWO5YmCIq462YUjBjMSPOF7Ic=";
  };

  cargoHash = "sha256-pt/GoXF/uSU78pZqG8PgFe+tlbwZH2qpGQD7jgC52NM=";
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate GitHub CODEOWNERS files from OWNERS files distributed through the file tree";
    homepage = "https://github.com/andrewring/github-distributed-owners";
    changelog = "https://github.com/andrewring/github-distributed-owners/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cameroncuttingedge ];
    mainProgram = "github-distributed-owners";
  };
})
