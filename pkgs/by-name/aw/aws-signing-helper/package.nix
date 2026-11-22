{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule (finalAttrs: {
  pname = "aws-signing-helper";
  version = "1.8.6";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-agO/Kj2gZa3zECHK1mN+GlGi47f6b7oBeifwm1WAst0=";
  };
  vendorHash = "sha256-55S1fSaG+O2FKVS18ibOdWjbAyvFZ9M0a/S4xEqTn34=";

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
