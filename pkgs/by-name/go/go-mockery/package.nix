{
  lib,
  buildGoModule, # sync with go below, update to latest release
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "go-mockery";
  version = "3.2.5";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    tag = "v${version}";
    hash = "sha256-QtfiW9yZvqCjKb3wH+QqfD98d7FLDVBQxj2Y/GC6Yhk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vektra/mockery/v${lib.versions.major version}/internal/logging.SemVer=v${version}"
  ];

  env.CGO_ENABLED = false;

  proxyVendor = true;
  vendorHash = "sha256-ac9wqHmkmpb1tIkQQ7x8+X+wQ217vsNm4IIidzNlne0=";
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/mockery";
  versionCheckProgramArg = "version";

  subPackages = [ "." ];

  meta = {
    homepage = "https://github.com/vektra/mockery";
    description = "Mock code autogenerator for Golang";
    maintainers = with lib.maintainers; [
      fbrs
      jk
    ];
    mainProgram = "mockery";
    license = lib.licenses.bsd3;
  };
}
