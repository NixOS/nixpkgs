{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule (finalAttrs: {
  pname = "aws-signing-helper";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6EtWOcSFSxvOkDXf1/OL6IoHv25+FMGGCbh/vjzkH6U=";
  };
  vendorHash = "sha256-acr1A+Yj+azdTaGHlNVW1ADMEFTpAVhUAP1yWkUpJ38=";

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
