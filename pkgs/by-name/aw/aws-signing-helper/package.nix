{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule rec {
  pname = "aws-signing-helper";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${version}";
    hash = "sha256-FmMs8oU1x85ESTD4Ap6f+OC6AW7W3sULPv1bScDrbL4=";
  };
  vendorHash = "sha256-znca4Zcy8brsPeSMpFSyojjKrborx/tx1wLBadWGYmQ=";

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
