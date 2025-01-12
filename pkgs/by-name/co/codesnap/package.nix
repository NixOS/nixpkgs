{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "codesnap";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "mistricky";
    repo = "CodeSnap";
    tag = "v${version}";
    hash = "sha256-i6aKtNXoGMT2FuzsPGGb/V1e4X5WW72DeiSNBrnJCbA=";
  };

  cargoHash = "sha256-ckOvjgyhZytL5BL/nQGus3kG5S5UkshnA5sbo5wmWhk=";

  cargoBuildFlags = [
    "-p"
    "codesnap-cli"
  ];
  cargoTestFlags = cargoBuildFlags;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for generating beautiful code snippets";
    homepage = "https://github.com/mistricky/CodeSnap";
    changelog = "https://github.com/mistricky/CodeSnap/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "codesnap";
  };
}
