{
  lib,
  buildGoModule,
  dockmate,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "dockmate";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "shubh-io";
    repo = "DockMate";
    tag = "v${version}";
    hash = "sha256-kepv8jY/hddRpJMhwr55k0R8CPBKtifjrGiRxoIUDXw=";
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  vendorHash = "sha256-/votTA5Rn8beq1PgHpC01D01VjBIwciPVN5eNc8iZRM=";

  # Skip tests that require a Docker daemon or interactive filesystem access,
  # as these are unavailable in the restricted Nix build sandbox.
  checkFlags = [
    "-skip=TestDockerComposeCommandNoFiles|TestDockerComposeCommandSingleFile|TestDockerComposeCommandMultipleFiles|TestWritingToConfigFile"
  ];

  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/shubh-io/DockMate/releases/tag/${src.tag}";
    description = "Terminal-based Docker container manager that actually works";
    homepage = "https://github.com/shubh-io/DockMate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sith-lord-vader
    ];
    mainProgram = "dockmate";
  };
}
