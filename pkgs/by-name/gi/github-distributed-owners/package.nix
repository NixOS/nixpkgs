{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "github-distributed-owners";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "andrewring";
    repo = "github-distributed-owners";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ry7l4hiVWtSm47DYG38N0L7V/z5wNfPm9tt+8Zs5tsI=";
  };

  cargoHash = "sha256-xLc9T2rS511/qWyZpqSNFVyfyf4+gzheOF95TpVlUfc=";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate GitHub CODEOWNERS files from OWNERS files distributed through the file tree";
    homepage = "https://github.com/andrewring/github-distributed-owners";
    changelog = "https://github.com/andrewring/github-distributed-owners/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "github-distributed-owners";
  };
})
