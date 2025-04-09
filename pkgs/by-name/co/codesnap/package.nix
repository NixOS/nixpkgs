{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "codesnap";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "mistricky";
    repo = "CodeSnap";
    tag = "v${version}";
    hash = "sha256-gDV66eLHcg7OuVR0Wo5x3anqKjnS/BsCCVaR6VOnM+s=";
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
  versionCheckProgramArg = "--version";
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
