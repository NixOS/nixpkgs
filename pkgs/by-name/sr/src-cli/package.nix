{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "src-cli";
  version = "6.10.0";

  src = fetchFromGitHub {
    owner = "sourcegraph";
    repo = "src-cli";
    rev = version;
    hash = "sha256-x35ER65LNw3049JLrRA5SyPjUYh/zXhRJM8FIp9iW60=";
  };

  vendorHash = "sha256-rsmgKSmgjtxeNhTrwA7RBtNAa7qyDKhbKSVmfP5AgFg=";

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
      keegancsmith
    ];
    mainProgram = "src";
  };
}
