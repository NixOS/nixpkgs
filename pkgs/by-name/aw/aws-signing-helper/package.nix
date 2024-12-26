{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule rec {
  pname = "aws-signing-helper";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${version}";
    hash = "sha256-CIUhO+5gMIknB3NwYwaBbtZEkW2x/U2Bi9Qbqn9bLuc=";
  };
  vendorHash = "sha256-QKKgBIocJoGbfs78PxNBLBi4KTDPtSuhzvsb6OBhNWQ=";

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
