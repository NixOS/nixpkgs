{
  buildGoModule,
  fetchFromGitHub,
  lib,
  bash,
}:
buildGoModule rec {
  pname = "aws-signing-helper";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "v${version}";
    hash = "sha256-aWSOSGv7JpRii/xYzLF1K58Lcvwywzw9AN9dNUZni/I=";
  };
  vendorHash = "sha256-8YkLeGtf8Il7V5rVk+YJgH03lx+Ivq6kcqZNXcUnyrc=";

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
