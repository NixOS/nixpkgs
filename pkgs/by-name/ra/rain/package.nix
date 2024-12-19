{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  rain,
}:

buildGoModule rec {
  pname = "rain";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "aws-cloudformation";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I5h09XbBDrMXQczpNoUENkOp3b4NxBR5Hr58nNVh1JM=";
  };

  vendorHash = "sha256-6xSWaLnE9pD2d49OVjg2IIbhgdJ5R2I0fuRZ4wFudoI=";

  subPackages = [ "cmd/rain" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = rain;
    command = "rain --version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Development workflow tool for working with AWS CloudFormation";
    mainProgram = "rain";
    homepage = "https://github.com/aws-cloudformation/rain";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
  };
}
