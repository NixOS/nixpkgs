{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "aws-signing-helper";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "rolesanywhere-credential-helper";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-1488l381449b4z3y5zyj121drax1v0ib0xhsmdy1prsmfck1k3xx";
  };
  vendorHash = "sha256-QKKgBIocJoGbfs78PxNBLBi4KTDPtSuhzvsb6OBhNWQ=";

  meta = {
    description = "AWS Signing Helper for IAM Roles Anywhere";
    homepage = "https://github.com/aws/rolesanywhere-credential-helper";
    changelog = "https://github.com/aws/rolesanywhere-credential-helper/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "aws-signing-helper";
    maintainers = with lib.maintainers; [ pandanz ];
  };
}