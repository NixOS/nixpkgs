{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "limbo";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "tursodatabase";
    repo = "limbo";
    tag = "v${version}";
    hash = "sha256-RTX/CRfUKvMSZhULhZD+PcYcc+a1gxANMxm+GmNyb3M=";
  };

  cargoHash = "sha256-BzVPaT7eGOQKRkZe2ZK4rWjHQ2WM7YVMo2siUhpGfOM=";

  cargoBuildFlags = [
    "-p"
    "limbo"
  ];
  cargoTestFlags = cargoBuildFlags;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive SQL shell for Limbo";
    homepage = "https://github.com/tursodatabase/limbo";
    changelog = "https://github.com/tursodatabase/limbo/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "limbo";
  };
}
