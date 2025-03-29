{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "codesnap";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "mistricky";
    repo = "CodeSnap";
    tag = "v${version}";
    hash = "sha256-g2Xu/PKRSYrHKDJ5/MZRUkDQeYuxvNWPTuymhI8Iu5Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bQT+tpoSZ54yppyNJxbOEqQoIKqYZAnRo0j42Ti+EJo=";

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
