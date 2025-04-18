{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "codesnap";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "mistricky";
    repo = "CodeSnap";
    tag = "v${version}";
    hash = "sha256-7miAizBKhUM1KGV+WKuOE3ENTsgSvwNtprvcs1R6ivU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-UDP4nlGF5GnNQdFo4aIYlgCn0HU+bNtJjEjcaO2f/U4=";

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
