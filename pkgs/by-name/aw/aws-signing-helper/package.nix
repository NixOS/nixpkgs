{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule rec {
  pname = "aws-signing-helper";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${version}";
    hash = "sha256-6yq/+LwYBfq0bHcZMqeU2mToo4QmkeoXeixn4ZFFfmM=";
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
    changelog = "https://github.com/aws/rolesanywhere-credential-helper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "aws_signing_helper";
    maintainers = with lib.maintainers; [ pandanz ];
  };
}
