{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule (finalAttrs: {
  pname = "rain";
  version = "1.24.3";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = "rain";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bLFElIc4bptxnKfboBU9r1jf1K9EV8f4iPQ7+7gEj4U=";
  };

  vendorHash = "sha256-uFDgNoQxEQHENWj+zks0KNjb4inBx3KunJOqe78pGR8=";

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
