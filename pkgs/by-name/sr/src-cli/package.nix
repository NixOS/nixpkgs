{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "src-cli";
  version = "6.7.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-uWbzHb0UIDly1r0f+AYNLCsduie7b0T6P1ZiUdrUBho=";
  };

  vendorHash = "sha256-bpfDnVqJoJi9WhlA6TDWAhBRkbbQn1BHfnLJ8BTmhGM=";

  subPackages = [ "cmd/src" ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/sourcegraph/src-cli/internal/version.BuildTag=${version}"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckScript = "${placeholder "out"}/bin/src version -client-only";
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Sourcegraph CLI";
    homepage = "https://github.com/sourcegraph/src-cli";
    changelog = "https://github.com/sourcegraph/src-cli/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      figsoda
      keegancsmith
    ];
    mainProgram = "src";
  };
}
