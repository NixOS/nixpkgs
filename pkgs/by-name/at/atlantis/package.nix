{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "atlantis";
  version = "0.48.2";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iA5khLkukcBwrpHA7U3tZGN3l6c+fow9j0uzbR2I49A=";
  };

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-PRqmqqXbrk93bbWGKYfGbDSDn4pxKjintrPs77Re2Uo=";

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
