{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule (finalAttrs: {
  pname = "aws-signing-helper";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cGzQ2rek0EA3ZaPfFOePhkYdKYj4cWZ1b40LAddf5TY=";
  };
  vendorHash = "sha256-rYoBYPHWixvM2iGn/jf4Op7/xkBnV0zKYSJtDnI3ulQ=";

  checkPhase = ''
    runHook preCheck
    export SHELL=${bash}/bin/bash
    go test ./cmd/...
    runHook postCheck
  '';

  postInstall = ''
    mv $out/bin/rolesanywhere-credential-helper $out/bin/aws_signing_helper
  '';

  meta = {
    description = "AWS Signing Helper for IAM Roles Anywhere";
    homepage = "https://github.com/aws/rolesanywhere-credential-helper";
    changelog = "https://github.com/aws/rolesanywhere-credential-helper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "aws_signing_helper";
    maintainers = with lib.maintainers; [ pandanz ];
  };
})
