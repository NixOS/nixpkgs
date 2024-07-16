{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
, versionCheckHook
}:

buildGoModule rec {
  pname = "go-critic";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "go-critic";
    repo = "go-critic";
    rev = "v${version}";
    hash = "sha256-v/7fc3MRQoMQCKqZQVuZEm5R9ha5wusN+hEzp7aBpNk=";
  };

  vendorHash = "sha256-Qw4t2v/5IZnpZX8sR26DL0SYrjvfuJSzDUpZ4G0u6hU=";

  subPackages = [
    "cmd/gocritic"
  ];

  allowGoReference = true;

  ldflags = [
    "-X main.Version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  versionCheckProgram = "gocritic";
  versionCheckProgramArg = "version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Most opinionated Go source code linter for code audit";
    homepage = "https://go-critic.com/";
    changelog = "https://github.com/go-critic/go-critic/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    mainProgram = "gocritic";
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
