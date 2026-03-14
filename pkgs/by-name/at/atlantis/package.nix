{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "atlantis";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xATQIpH0hw6E9zKKUU7ERlQ2CeTeLKeZiOyoUHaUgXA=";
  };

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-evYTKDpgdx0oQPtwqg/ZmFsTGNtnKB4vHbHhQ9eGgXQ=";

  subPackages = [ "." ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/atlantis";
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    mainProgram = "atlantis";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
