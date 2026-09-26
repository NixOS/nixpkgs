{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule (finalAttrs: {
  pname = "aws-signing-helper";
  version = "1.8.5";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XLQEGHM7cKm3n9pQdyzGWXN9Wre2DZyXZWuwa4CcU7E=";
  };
  vendorHash = "sha256-HLqId+mb+UbiX9M4xpCoDv257qKHUOuc6037WameY7Y=";

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
