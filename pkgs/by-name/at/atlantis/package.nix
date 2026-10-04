{
  lib,
  bash,
  buildGo127Module,
  fetchFromGitHub,
  git,
  makeWrapper,
  nixosTests,
  versionCheckHook,
}:

buildGo127Module (finalAttrs: {
  pname = "atlantis";
  version = "0.48.0";

  src = fetchFromGitHub {
    owner = "runatlantis";
    repo = "atlantis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/Ix/1WYhaNQdCIXhUvuEOsDZMrIwSdO2fr0TSUVZjOE=";
  };

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  vendorHash = "sha256-EfxLEqjYtLl4a2PYJxh7+kWyLf39KvtZugLBdAMOJPs=";

  subPackages = [ "." ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/atlantis \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          git
        ]
      }
  '';
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
