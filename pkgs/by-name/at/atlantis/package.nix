{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "atlantis";
  version = "0.50.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/NhnJ4a4uB9JaYmAtAk2ckWNVCw/Ntgh55KGyR48+og=";
  };

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-vK/Ef+ihYwDimSPBlMwBiFS/hfQYhERhXtLAx06Al/I=";

  subPackages = [ "." ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/atlantis";
  versionCheckProgramArg = "version";

  passthru.tests = {
    inherit (nixosTests) atlantis;
  };

  meta = {
    homepage = "https://github.com/runatlantis/atlantis";
    description = "Terraform Pull Request Automation";
    mainProgram = "atlantis";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      tebriel
    ];
  };
})
