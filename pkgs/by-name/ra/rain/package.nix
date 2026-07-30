{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule (finalAttrs: {
  pname = "rain";
  version = "1.24.4";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "rain";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-akckpNDlv9TuDVkFLEhsx61GYNMrjBE2cM/mXmVtrCA=";
  };

  vendorHash = "sha256-bREmqt9QDuPqhfTIIY1FBfOcNqGS8JXjlMqM99tBI9g=";

  subPackages = [ "cmd/rain" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = rain;
    command = "rain --version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Development workflow tool for working with AWS CloudFormation";
    mainProgram = "rain";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jiegec ];
  };
})
